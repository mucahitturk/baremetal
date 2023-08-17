/*. Entry Point *./
ENTRY(Reset_Handler)

/* Specify the memory areas */
MEMORY
{
  FLASH(rx):ORIGIN = 0x08000000,LENGTH = 1024K
  SRAM(rwx):ORIGIN = 0x20000000,LENGTH = 128K
}

/* Define output sections */
SECTIONS
{
  /* The program code and other data goes into FLASH */
  .text :
  {
    *(.isr_vector)
    *(.text)     /* .text sections (code) */
	*(.text.*)   /* .text* sections (code) */
	*(.init)
	*(.fini)
	*(.rodata)   /* .rodata sections (constants, strings, etc.) */
	*(.rodata.*) /* .rodata* sections (constants, strings, etc.) */
	. = ALIGN(4);
	_etext = .; /* define a global symbols at end of code */
  }> FLASH
  
  _la_data = LOADADDR(.data);
  
  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data :
  {
    _sdata = .; /* create a global symbol at data start */
	*(.data)    /* .data sections */
	*(.data.*)  /* .data* sections */
	. = ALIGN(4);
	_edata = .; /* define a global symbol at data end */
  }> SRAM AT> FLASH
  
  /* Uninitialized data section */
  .bss :
  {
    _sbss = .;              /* define a global symbol at bss start */
	__bss_start__ = _sbss;
	*(.bss)
	*(.bss.*)
	*(COMMON)
	. = ALIGN(4);
	_ebss = .;
	__bss_end__ = _ebss;
	   . = ALIGN(4); 
	end = .;
	__end__ = .;
  }> SRAM

}
