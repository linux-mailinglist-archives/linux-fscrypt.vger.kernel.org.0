Return-Path: <linux-fscrypt+bounces-997-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE28CAFB71
	for <lists+linux-fscrypt@lfdr.de>; Tue, 09 Dec 2025 12:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5250B301EC5D
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Dec 2025 11:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44F82EB5C6;
	Tue,  9 Dec 2025 11:08:19 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CF27AC31
	for <linux-fscrypt@vger.kernel.org>; Tue,  9 Dec 2025 11:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765278499; cv=none; b=I0y62eOkkEzZwHL7jz+uoRpFyK/gpg1f5kuuU0Jv9401oWl0WReQnbozpxy/W++maYvZaLu43fQK+dEvorYnmWGkCf7z4A1wfLuG+QaeLVTmwjFhxkLob9fcOjM+sfRmwm/+47+zf71AiLPKYKmBK3xGcNUmEjhenQDZ8A9Kcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765278499; c=relaxed/simple;
	bh=shT9tBjI8TIw5ux+mXWY7mqDfAQyY5tU76iB6CNoC1o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cvhn+DQ9NRTodW83yj/Qx/IsVb6qr+xjg86bkDcZE38BdLwXrGA/lQR83Juqohxh3OVaDhJ1r2DqLugl6tBUbXhTEMPvD7n8Jr3kI7gXVAD47+RSjl8vK7W/AhaeKs/E0e5p0sXLiqXH7RIn8nupYbCbYXzv6AdvVJJMBB7+xQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-656bc3a7ab3so8365790eaf.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 09 Dec 2025 03:08:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765278497; x=1765883297;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Xw/E3Vy0/7x6YxsDXNwWvkMieu2C5D/ay1KNYrFPxM=;
        b=ggSRXhYzI8O46Qd0/UJb1roI6LdFUdN22YsEecT50vfVQivbaYISliJdQefM2anphv
         6b5acXQXuYXtJr/jEBNrOsHC212dvf8rook7cp2VT5flxkDe5mTaBRCfSfHVf5tNasYl
         X8Cykzh+aToyLCaoPD9SKGI0dDPU3hoGqhkHUmSGC5kTa0aVlwZ0ShPu2eWF0cQQ2DQ+
         lWGjQP1YnKPC1TVAJxflpf2lJYTga7UmhwgqiiIT9Bws2zn3WnhkrtptmMfEJ2Ok8xQh
         6FF+wVSLtbukH3wW/cJ5AjBHK/HFedt3gcqAgKuBigV2Gl28R+Q7HEbRy+obeson8vCk
         39yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtabHX1qoi1TP2/o6KN88vjwoG/zNoX0B/VkKAUfXvJLtuuy340P2qy+1w2Gs9nyphtlEYWU/U96OJaTGW@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz1zKnCakoLZ4AP6smxKwCaN9GJovffovanQFJS/SndnKZUyG9
	sRHz576ZyVqZ/5OD9KlC8+ItsbwpPEg19klItFiwUiwxoe/WFzP3/kVOehoC5glBP6KrKTcqpMA
	BOA3BE56zLvlDQS848kdP3JfPy1fIRNpMFKrSlaunuHcX35Fx6qcwKhDtnso=
X-Google-Smtp-Source: AGHT+IG4WyPj9QFKCe40E58n+5dRuWKZAw89JrJTWJ6KuTr2vVvl3fO8VBeUHSBc4VUe7YhqveZVwlBUZGtZuYjryAm7S+lni48s
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1388:b0:659:9a49:8f9c with SMTP id
 006d021491bc7-6599a8cd164mr4480509eaf.21.1765278497044; Tue, 09 Dec 2025
 03:08:17 -0800 (PST)
Date: Tue, 09 Dec 2025 03:08:17 -0800
In-Reply-To: <68ee633c.050a0220.1186a4.002a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69380321.050a0220.1ff09b.0000.GAE@google.com>
Subject: Re: [syzbot] [ext4] [fscrypt] KMSAN: uninit-value in fscrypt_crypt_data_unit
From: syzbot <syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com>
To: davem@davemloft.net, ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	jaegeuk@kernel.org, linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    a110f942672c Merge tag 'pinctrl-v6.19-1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17495992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10d58c94af5f9772
dashboard link: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1122aec2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14012a1a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/905b868d0b1d/disk-a110f942.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa7281cd9720/vmlinux-a110f942.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1420de8a7da2/bzImage-a110f942.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1e40f788aa89/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1622aec2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 subshift lib/crypto/aes.c:150 [inline]
 aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
 aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
 crypto_ecb_crypt crypto/ecb.c:23 [inline]
 crypto_ecb_encrypt2+0x142/0x300 crypto/ecb.c:40
 crypto_lskcipher_crypt_sg+0x3ac/0x930 crypto/lskcipher.c:188
 crypto_lskcipher_encrypt_sg+0x8b/0xc0 crypto/lskcipher.c:207
 crypto_skcipher_encrypt+0x111/0x1e0 crypto/skcipher.c:443
 xts_encrypt+0x2e1/0x570 crypto/xts.c:269
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:444
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio+0x399/0x3d0 fs/ext4/inode.c:2087
 mpage_process_page_bufs+0xaef/0xf50 fs/ext4/inode.c:2198
 mpage_prepare_extent_to_map+0x175d/0x2660 fs/ext4/inode.c:2737
 ext4_do_writepages+0x1aa1/0x77a0 fs/ext4/inode.c:2930
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3026
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2598
 __writeback_single_inode+0x101/0x1190 fs/fs-writeback.c:1737
 writeback_sb_inodes+0xb2d/0x1f10 fs/fs-writeback.c:2030
 wb_writeback+0x4ce/0xc00 fs/fs-writeback.c:2216
 wb_do_writeback fs/fs-writeback.c:2363 [inline]
 wb_workfn+0x397/0x1910 fs/fs-writeback.c:2403
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3340
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3421
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x208/0x710 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Uninit was stored to memory at:
 le128_xor include/crypto/b128ops.h:69 [inline]
 xts_xor_tweak+0x566/0xbd0 crypto/xts.c:123
 xts_xor_tweak_pre crypto/xts.c:135 [inline]
 xts_encrypt+0x278/0x570 crypto/xts.c:268
 crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:444
 fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
 fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
 ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
 mpage_submit_folio+0x399/0x3d0 fs/ext4/inode.c:2087
 mpage_process_page_bufs+0xaef/0xf50 fs/ext4/inode.c:2198
 mpage_prepare_extent_to_map+0x175d/0x2660 fs/ext4/inode.c:2737
 ext4_do_writepages+0x1aa1/0x77a0 fs/ext4/inode.c:2930
 ext4_writepages+0x338/0x870 fs/ext4/inode.c:3026
 do_writepages+0x3f2/0x860 mm/page-writeback.c:2598
 __writeback_single_inode+0x101/0x1190 fs/fs-writeback.c:1737
 writeback_sb_inodes+0xb2d/0x1f10 fs/fs-writeback.c:2030
 wb_writeback+0x4ce/0xc00 fs/fs-writeback.c:2216
 wb_do_writeback fs/fs-writeback.c:2363 [inline]
 wb_workfn+0x397/0x1910 fs/fs-writeback.c:2403
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3340
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3421
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x208/0x710 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Uninit was created at:
 __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof mm/mempolicy.c:2577 [inline]
 folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2587
 filemap_alloc_folio_noprof+0xda/0x480 mm/filemap.c:1013
 __filemap_get_folio_mpol+0xb4f/0x1960 mm/filemap.c:2006
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 write_begin_get_folio include/linux/pagemap.h:789 [inline]
 ext4_write_begin+0x6d3/0x2d70 fs/ext4/inode.c:1323
 generic_perform_write+0x365/0x1050 mm/filemap.c:4314
 ext4_buffered_write_iter+0x61a/0xce0 fs/ext4/file.c:299
 ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
 aio_write+0x704/0xa10 fs/aio.c:1634
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x260e/0x3450 fs/aio.c:2053
 __do_sys_io_submit fs/aio.c:2112 [inline]
 __se_sys_io_submit+0x27c/0x6a0 fs/aio.c:2082
 __x64_sys_io_submit+0x97/0xe0 fs/aio.c:2082
 x64_sys_call+0x3b5f/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:210
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 1143 Comm: kworker/u8:8 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: writeback wb_workfn (flush-7:0)
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

