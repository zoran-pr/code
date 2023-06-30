#!/usr/bin/env python
from os import getcwd, walk, pardir
from os.path import abspath, join, isdir, isfile, dirname, basename, splitext
from shutil import move
import sys

def main():
    global src_path 
    src_path = ask_path('Path or <Enter> for  current DIR: ')
    src_files_tup = get_src_files(src_path)

    do_rename(src_files_tup)
    print('Done renaming')

def ask_path(q):
    src_path = input(q)
    if not src_path:
        src_path = getcwd()
    return src_path

def get_src_files(src_path):
    tup = ()
    #src_ext = ( '.srt', '.mkv', '.mp4')
    src_ext = '.mkv'
    for r, d , f in walk(src_path, topdown=True):
        for file in f:
            d.sort()
            if file[0].isdigit():
                file = join(r, file)
                tup += ((file), )
    sorted(tup)
    return tup        

def do_rename(tup):
    dir_dict = {}
    file_dict = {}
    for src_file in tup:
        src_dir = dirname(src_file)

        dir_name = basename(src_dir)
        dir_dir = abspath(join(src_dir, pardir))
        
        src_fullname = basename(src_file)
        src_name = splitext(src_fullname)[0] 
        src_ext = splitext(src_fullname)[1]

        if src_name[0].isdigit or dir_name[0].isdigit:
            old_fname = src_file
            old_fprefix = src_name.split(' ',1)[0]
            new_fprefix = f'{int(old_fprefix):04} '
            #new_fprefix = '%03d' % int(old_fprefix)
            new_fname = src_name.split(' ', 1)[1]
            new_fname = join(src_dir, new_fprefix + new_fname) + src_ext    

            old_dname = join(dir_dir, dir_name)
            old_dprefix = dir_name.split(' ', 1)[0]
            new_dprefix = f'{int(old_dprefix):03} '
            new_dname = dir_name.split(' ', 1)[1]
            new_dname = join(dir_dir, new_dprefix + new_dname)
            if isfile(old_fname):
                move(old_fname, new_fname )
            if isdir(old_dname):
                move(old_dname, new_dname)

if __name__ == '__main__':
    main()