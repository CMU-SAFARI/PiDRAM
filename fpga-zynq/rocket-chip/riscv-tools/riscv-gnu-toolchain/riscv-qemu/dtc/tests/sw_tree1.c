/*
 * libfdt - Flat Device Tree manipulation
 *	Testcase for fdt_nop_node()
 * Copyright (C) 2006 David Gibson, IBM Corporation.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

#include <libfdt.h>

#include "tests.h"
#include "testdata.h"

#define SPACE	65536

#define CHECK(code) \
	{ \
		err = (code); \
		if (err) \
			FAIL(#code ": %s", fdt_strerror(err)); \
	}

int main(int argc, char *argv[])
{
	void *fdt;
	int err;

	test_init(argc, argv);

	fdt = xmalloc(SPACE);
	CHECK(fdt_create(fdt, SPACE));

	CHECK(fdt_add_reservemap_entry(fdt, TEST_ADDR_1, TEST_SIZE_1));
	CHECK(fdt_add_reservemap_entry(fdt, TEST_ADDR_2, TEST_SIZE_2));
	CHECK(fdt_finish_reservemap(fdt));

	CHECK(fdt_begin_node(fdt, ""));
	CHECK(fdt_property_string(fdt, "compatible", "test_tree1"));
	CHECK(fdt_property_u32(fdt, "prop-int", TEST_VALUE_1));
	CHECK(fdt_property_u64(fdt, "prop-int64", TEST_VALUE64_1));
	CHECK(fdt_property_string(fdt, "prop-str", TEST_STRING_1));

	CHECK(fdt_begin_node(fdt, "subnode@1"));
	CHECK(fdt_property_string(fdt, "compatible", "subnode1"));
	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_1));
	CHECK(fdt_begin_node(fdt, "subsubnode"));
	CHECK(fdt_property(fdt, "compatible", "subsubnode1\0subsubnode",
			   23));
	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_1));
	CHECK(fdt_end_node(fdt));
	CHECK(fdt_begin_node(fdt, "ss1"));
	CHECK(fdt_end_node(fdt));
	CHECK(fdt_end_node(fdt));

	CHECK(fdt_begin_node(fdt, "subnode@2"));
	CHECK(fdt_property_cell(fdt, "linux,phandle", PHANDLE_1));
	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_2));
	CHECK(fdt_begin_node(fdt, "subsubnode@0"));
	CHECK(fdt_property_cell(fdt, "phandle", PHANDLE_2));
	CHECK(fdt_property(fdt, "compatible", "subsubnode2\0subsubnode",
			   23));
	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_2));
	CHECK(fdt_end_node(fdt));
	CHECK(fdt_begin_node(fdt, "ss2"));
	CHECK(fdt_end_node(fdt));

	CHECK(fdt_end_node(fdt));

	CHECK(fdt_end_node(fdt));

	save_blob("unfinished_tree1.test.dtb", fdt);

	CHECK(fdt_finish(fdt));

	verbose_printf("Completed tree, totalsize = %d\n",
		       fdt_totalsize(fdt));

	save_blob("sw_tree1.test.dtb", fdt);

	PASS();
}
