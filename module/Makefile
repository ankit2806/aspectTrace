obj-m := prof.o
prof-objs := print_msgs.o process_main.o process_func.o init_prof.o procfile_impl.o procfile_impl_main.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
