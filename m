Return-Path: <linux-fscrypt+bounces-286-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D43518D448C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 May 2024 06:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 470401F224A5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 May 2024 04:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EC814387F;
	Thu, 30 May 2024 04:31:54 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8371B37171;
	Thu, 30 May 2024 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717043514; cv=none; b=lnG/i73ODEfJbjxsXDq4FbPGaxkLJBTBN2JxZNyvMndIpzL+PH/MciywDFS41gCpVfVlCaymMd12r7gZRlHJbciQD79EOKJm+w7SbsBy5I6RM27RMojwqQTpWxMsewjrCOxlaKLTzBBUgissTkx1G6wrz9cDNXw9NLWfDzvaReo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717043514; c=relaxed/simple;
	bh=UISANedLyvwh32D5vXLunbfBPBzWbKBm5+TC6Ngp7Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOVOKE13MO1wM/0r1oudL8IKk616niPUQySqpQojf+3y6CuPs/Ckk6iW+fwANp07lXOW+5MJUwd2snWccXVnguVevdF3SwXDaluFnTsk+jPVHni9jGkRQcR0ZSk+N0Tu7xvr8To3iG1Klzxoo6sz5cqK13o+IUWLwOU3vlrd0/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCXRi-003fQ3-1H;
	Thu, 30 May 2024 12:31:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 May 2024 12:31:24 +0800
Date: Thu, 30 May 2024 12:31:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+aeb14e2539ffb6d21130@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in aes_encrypt (5)
Message-ID: <ZlgBHEnZQSftdqCv@gondor.apana.org.au>
References: <0000000000000fe556061725a7be@google.com>
 <00000000000099249d0618119a0c@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000099249d0618119a0c@google.com>

On Thu, May 09, 2024 at 09:02:27PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14d9bfdf180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=617171361dd3cd47
> dashboard link: https://syzkaller.appspot.com/bug?extid=aeb14e2539ffb6d21130
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1617adb8980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112f45d4980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/232e7c2a73a5/disk-45db3ab7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7e9bf7c936ab/vmlinux-45db3ab7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5e8f98ee02d8/bzImage-45db3ab7.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/fcc88c919ed9/mount_1.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+aeb14e2539ffb6d21130@syzkaller.appspotmail.com
> 
> fscrypt: AES-256-XTS using implementation "xts(ecb(aes-fixed-time))"
> =====================================================
> BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:149 [inline]
> BUG: KMSAN: uninit-value in aes_encrypt+0x15cc/0x1db0 lib/crypto/aes.c:282
>  subshift lib/crypto/aes.c:149 [inline]
>  aes_encrypt+0x15cc/0x1db0 lib/crypto/aes.c:282
>  aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
>  crypto_ecb_crypt crypto/ecb.c:23 [inline]
>  crypto_ecb_encrypt2+0x18a/0x300 crypto/ecb.c:40
>  crypto_lskcipher_crypt_sg+0x36b/0x7f0 crypto/lskcipher.c:228
>  crypto_lskcipher_encrypt_sg+0x8a/0xc0 crypto/lskcipher.c:247
>  crypto_skcipher_encrypt+0x119/0x1e0 crypto/skcipher.c:669
>  xts_encrypt+0x3c4/0x550 crypto/xts.c:269
>  crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
>  fscrypt_crypt_data_unit+0x4ee/0x8f0 fs/crypto/crypto.c:144
>  fscrypt_encrypt_pagecache_blocks+0x422/0x900 fs/crypto/crypto.c:207
>  ext4_bio_write_folio+0x13db/0x2e40 fs/ext4/page-io.c:526
>  mpage_submit_folio+0x351/0x4a0 fs/ext4/inode.c:1869
>  mpage_process_page_bufs+0xb92/0xe30 fs/ext4/inode.c:1982
>  mpage_prepare_extent_to_map+0x1702/0x22c0 fs/ext4/inode.c:2490
>  ext4_do_writepages+0x1117/0x62e0 fs/ext4/inode.c:2632
>  ext4_writepages+0x312/0x830 fs/ext4/inode.c:2768
>  do_writepages+0x427/0xc30 mm/page-writeback.c:2612
>  filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
>  __filemap_fdatawrite_range mm/filemap.c:430 [inline]
>  file_write_and_wait_range+0x1bf/0x370 mm/filemap.c:788
>  generic_buffers_fsync_noflush+0x84/0x3e0 fs/buffer.c:602
>  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
>  ext4_sync_file+0x5ba/0x13a0 fs/ext4/fsync.c:151
>  vfs_fsync_range+0x20d/0x270 fs/sync.c:188
>  generic_write_sync include/linux/fs.h:2795 [inline]
>  ext4_buffered_write_iter+0x9ad/0xaa0 fs/ext4/file.c:305
>  ext4_file_write_iter+0x208/0x3450
>  call_write_iter include/linux/fs.h:2110 [inline]
>  new_sync_write fs/read_write.c:497 [inline]
>  vfs_write+0xb63/0x1520 fs/read_write.c:590
>  ksys_write+0x20f/0x4c0 fs/read_write.c:643
>  __do_sys_write fs/read_write.c:655 [inline]
>  __se_sys_write fs/read_write.c:652 [inline]
>  __x64_sys_write+0x93/0xe0 fs/read_write.c:652
>  x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Uninit was stored to memory at:
>  le128_xor include/crypto/b128ops.h:69 [inline]
>  xts_xor_tweak+0x4ae/0xbf0 crypto/xts.c:123
>  xts_xor_tweak_pre crypto/xts.c:135 [inline]
>  xts_encrypt+0x296/0x550 crypto/xts.c:268
>  crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
>  fscrypt_crypt_data_unit+0x4ee/0x8f0 fs/crypto/crypto.c:144
>  fscrypt_encrypt_pagecache_blocks+0x422/0x900 fs/crypto/crypto.c:207
>  ext4_bio_write_folio+0x13db/0x2e40 fs/ext4/page-io.c:526
>  mpage_submit_folio+0x351/0x4a0 fs/ext4/inode.c:1869
>  mpage_process_page_bufs+0xb92/0xe30 fs/ext4/inode.c:1982
>  mpage_prepare_extent_to_map+0x1702/0x22c0 fs/ext4/inode.c:2490
>  ext4_do_writepages+0x1117/0x62e0 fs/ext4/inode.c:2632
>  ext4_writepages+0x312/0x830 fs/ext4/inode.c:2768
>  do_writepages+0x427/0xc30 mm/page-writeback.c:2612
>  filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
>  __filemap_fdatawrite_range mm/filemap.c:430 [inline]
>  file_write_and_wait_range+0x1bf/0x370 mm/filemap.c:788
>  generic_buffers_fsync_noflush+0x84/0x3e0 fs/buffer.c:602
>  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
>  ext4_sync_file+0x5ba/0x13a0 fs/ext4/fsync.c:151
>  vfs_fsync_range+0x20d/0x270 fs/sync.c:188
>  generic_write_sync include/linux/fs.h:2795 [inline]
>  ext4_buffered_write_iter+0x9ad/0xaa0 fs/ext4/file.c:305
>  ext4_file_write_iter+0x208/0x3450
>  call_write_iter include/linux/fs.h:2110 [inline]
>  new_sync_write fs/read_write.c:497 [inline]
>  vfs_write+0xb63/0x1520 fs/read_write.c:590
>  ksys_write+0x20f/0x4c0 fs/read_write.c:643
>  __do_sys_write fs/read_write.c:655 [inline]
>  __se_sys_write fs/read_write.c:652 [inline]
>  __x64_sys_write+0x93/0xe0 fs/read_write.c:652
>  x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Uninit was created at:
>  __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
>  alloc_pages_mpol+0x299/0x990 mm/mempolicy.c:2264
>  alloc_pages mm/mempolicy.c:2335 [inline]
>  folio_alloc+0x1d0/0x230 mm/mempolicy.c:2342
>  filemap_alloc_folio+0xa6/0x440 mm/filemap.c:984
>  __filemap_get_folio+0xa10/0x14b0 mm/filemap.c:1926
>  ext4_write_begin+0x3e5/0x2230 fs/ext4/inode.c:1159
>  generic_perform_write+0x400/0xc60 mm/filemap.c:3974
>  ext4_buffered_write_iter+0x564/0xaa0 fs/ext4/file.c:299
>  ext4_file_write_iter+0x208/0x3450
>  call_write_iter include/linux/fs.h:2110 [inline]
>  new_sync_write fs/read_write.c:497 [inline]
>  vfs_write+0xb63/0x1520 fs/read_write.c:590
>  ksys_write+0x20f/0x4c0 fs/read_write.c:643
>  __do_sys_write fs/read_write.c:655 [inline]
>  __se_sys_write fs/read_write.c:652 [inline]
>  __x64_sys_write+0x93/0xe0 fs/read_write.c:652
>  x64_sys_call+0x3062/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:2
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> CPU: 0 PID: 5048 Comm: syz-executor132 Not tainted 6.9.0-rc7-syzkaller-00056-g45db3ab70092 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
> =====================================================
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

#syz set subsystems: ext4

These reports have been coming in for a while, previously they were
merged incorrectly with reports coming from networking, see for
example:

https://syzkaller.appspot.com/bug?id=6eb713b7107c62e9f6c259adf944c96efc3cd524
https://syzkaller.appspot.com/text?tag=CrashReport&x=11e16a77a80000

The networking bug disappeared mysteriously in July 2023.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

