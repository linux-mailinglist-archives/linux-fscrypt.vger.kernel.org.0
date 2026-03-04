Return-Path: <linux-fscrypt+bounces-1492-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE1INgHip2mrlAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1492-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 08:40:49 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 356781FBBA8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 08:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C28A33015E03
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2026 07:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0E4370D54;
	Wed,  4 Mar 2026 07:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/Yi143U"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DC636F40D;
	Wed,  4 Mar 2026 07:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609869; cv=none; b=MDKvH5hiIESWRdW5iw/6YOR8ZVWKcTsjJ8zAhbm644azRAgzSbpc+W1I7ocvli2SnUgCxZT/ItqV7MCtEIYJs8q/+C/3gRWo9rEnhro753DRAxcVFVDjIlhzt064idMmOeYsQZIDWWih0/3IuEYcnZq2DNBdsEfiEcWpTCJqVp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609869; c=relaxed/simple;
	bh=2ZQD1N2O5StB08VmKqUsZuO7vnRQfo5Om7tixlyuwQc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LuuFtHQ6WwuZYWB5+E1bKfBRBrHiDuZdeoDU3QugBPZKNp/0gbqGrdPjRW1BLTELGnWjgh+KlgVP9iythiwLIolajrkzNWIRfekFjUBvwTHBk8bMl1oykPdKZPjX7j3r5u3z3g488mrooE4aohRAMAG1p18Sxrgu06MYkv8SgEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/Yi143U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12461C19423;
	Wed,  4 Mar 2026 07:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772609868;
	bh=2ZQD1N2O5StB08VmKqUsZuO7vnRQfo5Om7tixlyuwQc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=e/Yi143U/D/fifsEf1zhGTOR5752tLI6dOu7lRYyFfmeRiuugxC8znnWBi70vlJvq
	 Z0L6h32MbeHFGZn35G37S6Yh1nR3zo1uHm9UpWD/5eF6kfhVuRaendjlgO/0VBekzg
	 Ydj2/dsg7FFsOvDm+uJhLyN1P6OM4Be2codPM/E7EHeCuGkyw56yBoD2iJfyayl8Kf
	 zFM4acXckJPJdBSN/nMfXeyKJ98yJNhaBYoRI4FSylS/eAVV8444X8jGODT/50GL7t
	 BKB16nuQSaeA+z9v1lF/fHFIniyH0aL3lQGos1saiOJoKHR0EJxrfKZFHkbNvj+EfT
	 IQBXjMPjY6KSQ==
Message-ID: <efdfa39e-78f5-47df-9de5-a5d8ae8841b2@kernel.org>
Date: Wed, 4 Mar 2026 15:37:43 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org
Subject: Re: [syzbot] [fscrypt?] [f2fs?] memory leak in fscrypt_setup_filename
To: syzbot <syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com>,
 ebiggers@kernel.org, jaegeuk@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
References: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 356781FBBA8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1492-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,appspotmail.com:email,storage.googleapis.com:url,goo.gl:url,googlegroups.com:email];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_NEQ_ENVFROM(0.00)[chao@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt,cf7946ab25b21abc4b66];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Action: no action

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git bugfix/syzbot

On 2026/3/4 06:25, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    af4e9ef3d784 uaccess: Fix scoped_user_read_access() for 'p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12506d5a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
> dashboard link: https://syzkaller.appspot.com/bug?extid=cf7946ab25b21abc4b66
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160a18d6580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e2b0ba580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/70cb2ebe1e6e/disk-af4e9ef3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/945fea3c8a6d/vmlinux-af4e9ef3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fa6a6a5cbcc8/bzImage-af4e9ef3.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/c12ae92fa9b6/mount_0.gz
>    fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=10e1d202580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff888127f70830 (size 16):
>    comm "syz.0.23", pid 6144, jiffies 4294943712
>    hex dump (first 16 bytes):
>      3c af 57 72 5b e6 8f ad 6e 8e fd 33 42 39 03 ff  <.Wr[...n..3B9..
>    backtrace (crc 925f8a80):
>      kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>      slab_post_alloc_hook mm/slub.c:4520 [inline]
>      slab_alloc_node mm/slub.c:4844 [inline]
>      __do_kmalloc_node mm/slub.c:5237 [inline]
>      __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
>      kmalloc_noprof include/linux/slab.h:954 [inline]
>      fscrypt_setup_filename+0x15e/0x3b0 fs/crypto/fname.c:364
>      f2fs_setup_filename+0x52/0xb0 fs/f2fs/dir.c:143
>      f2fs_rename+0x159/0xca0 fs/f2fs/namei.c:961
>      f2fs_rename2+0xd5/0xf20 fs/f2fs/namei.c:1308
>      vfs_rename+0x7ff/0x1250 fs/namei.c:6026
>      filename_renameat2+0x4f4/0x660 fs/namei.c:6144
>      __do_sys_renameat2 fs/namei.c:6173 [inline]
>      __se_sys_renameat2 fs/namei.c:6168 [inline]
>      __x64_sys_renameat2+0x59/0x80 fs/namei.c:6168
>      do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>      do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup


