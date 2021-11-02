/*
 * coroutine queues and locks
 *
 * Copyright (c) 2011 Kevin Wolf <kwolf@redhat.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "qemu/coroutine.h"
#include "qemu/coroutine_int.h"
#include "qemu/queue.h"
#include "trace.h"

void qemu_co_queue_init(CoQueue *queue)
{
    QSIMPLEQ_INIT(&queue->entries);
}

void coroutine_fn qemu_co_queue_wait(CoQueue *queue)
{
    Coroutine *self = qemu_coroutine_self();
    QSIMPLEQ_INSERT_TAIL(&queue->entries, self, co_queue_next);
    qemu_coroutine_yield();
    assert(qemu_in_coroutine());
}

/**
 * qemu_co_queue_run_restart:
 *
 * Enter each coroutine that was previously marked for restart by
 * qemu_co_queue_next() or qemu_co_queue_restart_all().  This function is
 * invoked by the core coroutine code when the current coroutine yields or
 * terminates.
 */
void qemu_co_queue_run_restart(Coroutine *co)
{
    Coroutine *next;

    trace_qemu_co_queue_run_restart(co);
    while ((next = QSIMPLEQ_FIRST(&co->co_queue_wakeup))) {
        QSIMPLEQ_REMOVE_HEAD(&co->co_queue_wakeup, co_queue_next);
        qemu_coroutine_enter(next);
    }
}

static bool qemu_co_queue_do_restart(CoQueue *queue, bool single)
{
    Coroutine *self = qemu_coroutine_self();
    Coroutine *next;

    if (QSIMPLEQ_EMPTY(&queue->entries)) {
        return false;
    }

    while ((next = QSIMPLEQ_FIRST(&queue->entries)) != NULL) {
        QSIMPLEQ_REMOVE_HEAD(&queue->entries, co_queue_next);
        QSIMPLEQ_INSERT_TAIL(&self->co_queue_wakeup, next, co_queue_next);
        trace_qemu_co_queue_next(next);
        if (single) {
            break;
        }
    }
    return true;
}

bool coroutine_fn qemu_co_queue_next(CoQueue *queue)
{
    assert(qemu_in_coroutine());
    return qemu_co_queue_do_restart(queue, true);
}

void coroutine_fn qemu_co_queue_restart_all(CoQueue *queue)
{
    assert(qemu_in_coroutine());
    qemu_co_queue_do_restart(queue, false);
}

bool qemu_co_enter_next(CoQueue *queue)
{
    Coroutine *next;

    next = QSIMPLEQ_FIRST(&queue->entries);
    if (!next) {
        return false;
    }

    QSIMPLEQ_REMOVE_HEAD(&queue->entries, co_queue_next);
    qemu_coroutine_enter(next);
    return true;
}

bool qemu_co_queue_empty(CoQueue *queue)
{
    return QSIMPLEQ_FIRST(&queue->entries) == NULL;
}

void qemu_co_mutex_init(CoMutex *mutex)
{
    memset(mutex, 0, sizeof(*mutex));
    qemu_co_queue_init(&mutex->queue);
}

void coroutine_fn qemu_co_mutex_lock(CoMutex *mutex)
{
    Coroutine *self = qemu_coroutine_self();

    trace_qemu_co_mutex_lock_entry(mutex, self);

    while (mutex->locked) {
        qemu_co_queue_wait(&mutex->queue);
    }

    mutex->locked = true;
    mutex->holder = self;
    self->locks_held++;

    trace_qemu_co_mutex_lock_return(mutex, self);
}

void coroutine_fn qemu_co_mutex_unlock(CoMutex *mutex)
{
    Coroutine *self = qemu_coroutine_self();

    trace_qemu_co_mutex_unlock_entry(mutex, self);

    assert(mutex->locked == true);
    assert(mutex->holder == self);
    assert(qemu_in_coroutine());

    mutex->locked = false;
    mutex->holder = NULL;
    self->locks_held--;
    qemu_co_queue_next(&mutex->queue);

    trace_qemu_co_mutex_unlock_return(mutex, self);
}

void qemu_co_rwlock_init(CoRwlock *lock)
{
    memset(lock, 0, sizeof(*lock));
    qemu_co_queue_init(&lock->queue);
}

void qemu_co_rwlock_rdlock(CoRwlock *lock)
{
    Coroutine *self = qemu_coroutine_self();

    while (lock->writer) {
        qemu_co_queue_wait(&lock->queue);
    }
    lock->reader++;
    self->locks_held++;
}

void qemu_co_rwlock_unlock(CoRwlock *lock)
{
    Coroutine *self = qemu_coroutine_self();

    assert(qemu_in_coroutine());
    if (lock->writer) {
        lock->writer = false;
        qemu_co_queue_restart_all(&lock->queue);
    } else {
        lock->reader--;
        assert(lock->reader >= 0);
        /* Wakeup only one waiting writer */
        if (!lock->reader) {
            qemu_co_queue_next(&lock->queue);
        }
    }
    self->locks_held--;
}

void qemu_co_rwlock_wrlock(CoRwlock *lock)
{
    Coroutine *self = qemu_coroutine_self();

    while (lock->writer || lock->reader) {
        qemu_co_queue_wait(&lock->queue);
    }
    lock->writer = true;
    self->locks_held++;
}
