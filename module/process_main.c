//file to get the data from task_struct

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <asm/io.h>
#include "decls.h"

extern int _pid;			//pid from procfile_impl.c

void get_mem_main(struct task_struct *task)
{
	struct mm_struct *_mm;
	struct vm_area_struct *_vm;
	struct file *_vm_file;
	struct address_space *_fmap;
	unsigned long int cnt = 0;
	
	_mm = task->active_mm;
	_vm = _mm->mmap;
	_vm_file = _vm->vm_file;
	_fmap = _vm_file->f_mapping;
	
	#ifndef CONFIG_MMU
		print_data("Memory Design: MMU");
	#endif
	#ifndef CONFIG_NUMA
		print_data("Memory Design: NUMA");
	#endif
	
	print_data("Virtual Memory Info:");
	print_msg_int("Start Code:",_mm->start_code);
	print_msg_int("End Code:",_mm->end_code);
	print_msg_size_int("Code size:",_mm->end_code-_mm->start_code);
	print_data("\n");
	print_msg_int("Start Data:",_mm->start_data);
	print_msg_int("End Data:",_mm->end_data);
	print_msg_size_int("Data size:",_mm->end_data-_mm->start_data);
	print_data("\n");
	print_msg_int("Start Heap:",_mm->start_brk);
	print_msg_int("End Heap:",_mm->brk);
	print_msg_size_int("Heap size:",_mm->brk-_mm->start_brk);
	print_data("\n");
	print_msg_int("Start Stack:",_mm->start_stack);

	while(_vm->vm_next != NULL)
	{
		cnt += _vm->vm_end - _vm->vm_start;
		_vm = _vm->vm_next;
	}
	
	print_msg_size_int("Total virtual memory allocated:",cnt);
}

void find_task_main()
{
	struct task_struct *task;
	
	for_each_process(task)
	{
		if(task->pid == _pid)
			get_mem_main(task);
			
	}
}
