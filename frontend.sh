- name: Roboshop project
  hosts: all
  become: true
  tasks:
      - name: install nginx
        ansible.builtin.yum:
            name: nginx
            state: latest

      - name: copy roboshop file
        ansible.builtin.copy:
          src: roboshop.conf
          dest: /etc/nginx/default.d/roboshop.conf

      - name: clean old content
        ansible.builtin.file:
          path: /usr/share/nginx/html/*
          state: absent

      - name: create directory
        ansible.builtin.file:
          path: /usr/share/nginx/html
          state: directory

      - name: Download and extract application content
        ansible.builtin.unarchive:
          src: https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
          dest: /usr/share/nginx/html
          remote_src: yes

      - name : restart nginx
        ansible.builtin.systemd:
            name: nginx
            state: restarted
            enabled: true
