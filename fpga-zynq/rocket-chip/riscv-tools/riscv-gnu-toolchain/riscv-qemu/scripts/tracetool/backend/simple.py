#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Simple built-in backend.
"""

__author__     = "Lluís Vilanova <vilanova@ac.upc.edu>"
__copyright__  = "Copyright 2012-2014, Lluís Vilanova <vilanova@ac.upc.edu>"
__license__    = "GPL version 2 or (at your option) any later version"

__maintainer__ = "Stefan Hajnoczi"
__email__      = "stefanha@linux.vnet.ibm.com"


from tracetool import out


PUBLIC = True


def is_string(arg):
    strtype = ('const char*', 'char*', 'const char *', 'char *')
    if arg.lstrip().startswith(strtype):
        return True
    else:
        return False


def generate_h_begin(events):
    for event in events:
        out('void _simple_%(api)s(%(args)s);',
            api=event.api(),
            args=event.args)
    out('')


def generate_h(event):
    out('        _simple_%(api)s(%(args)s);',
        api=event.api(),
        args=", ".join(event.args.names()))


def generate_c_begin(events):
    out('#include "qemu/osdep.h"',
        '#include "trace.h"',
        '#include "trace/control.h"',
        '#include "trace/simple.h"',
        '')


def generate_c(event):
    out('void _simple_%(api)s(%(args)s)',
        '{',
        '    TraceBufferRecord rec;',
        api=event.api(),
        args=event.args)
    sizes = []
    for type_, name in event.args:
        if is_string(type_):
            out('    size_t arg%(name)s_len = %(name)s ? MIN(strlen(%(name)s), MAX_TRACE_STRLEN) : 0;',
                name=name)
            strsizeinfo = "4 + arg%s_len" % name
            sizes.append(strsizeinfo)
        else:
            sizes.append("8")
    sizestr = " + ".join(sizes)
    if len(event.args) == 0:
        sizestr = '0'

    event_id = 'TRACE_' + event.name.upper()
    if "vcpu" in event.properties:
        # already checked on the generic format code
        cond = "true"
    else:
        cond = "trace_event_get_state(%s)" % event_id

    out('',
        '    if (!%(cond)s) {',
        '        return;',
        '    }',
        '',
        '    if (trace_record_start(&rec, %(event_id)s, %(size_str)s)) {',
        '        return; /* Trace Buffer Full, Event Dropped ! */',
        '    }',
        cond=cond,
        event_id=event_id,
        size_str=sizestr)

    if len(event.args) > 0:
        for type_, name in event.args:
            # string
            if is_string(type_):
                out('    trace_record_write_str(&rec, %(name)s, arg%(name)s_len);',
                    name=name)
            # pointer var (not string)
            elif type_.endswith('*'):
                out('    trace_record_write_u64(&rec, (uintptr_t)(uint64_t *)%(name)s);',
                    name=name)
            # primitive data type
            else:
                out('    trace_record_write_u64(&rec, (uint64_t)%(name)s);',
                   name=name)

    out('    trace_record_finish(&rec);',
        '}',
        '')
