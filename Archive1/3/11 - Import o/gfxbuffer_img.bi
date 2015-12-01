extern as ulong gfxbuffer_img_size  alias "gfxbuffer_img_size" 
dim shared as any ptr gfxbuffer_img_ptr 
asm mov dword ptr [gfxbuffer_img_ptr], offset gfxbuffer_img 
