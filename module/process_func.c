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

void get_mem_func(struct task_struct *task)
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
	
	while(_vm->vm_next != NULL)
	{
		cnt += _vm->vm_end - _vm->vm_start;
		_vm = _vm->vm_next;
	}
	
	print_msg_size_int("Total virtual memory allocated:",cnt);
}

void find_task_func()
{
	struct task_struct *task;
	
	for_each_process(task)
	{
		if(task->pid == _pid)
			get_mem_func(task);
	}
}
