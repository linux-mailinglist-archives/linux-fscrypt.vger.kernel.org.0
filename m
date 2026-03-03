Return-Path: <linux-fscrypt+bounces-1486-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCZZHuZfp2l2hAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1486-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Mar 2026 23:25:42 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7F01F7F66
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Mar 2026 23:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 672963040FC2
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Mar 2026 22:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A334438F623;
	Tue,  3 Mar 2026 22:25:39 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C98382F0A
	for <linux-fscrypt@vger.kernel.org>; Tue,  3 Mar 2026 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772576739; cv=none; b=kf000LhbYfVtyV9MO684SAo2ZRIE4Mv17vgXcKDu3XDfNrFudUjuUF1TlDPCJhmyh5vJBP1wPz6dBLd7EqB4ZZ5RXtzztJoqx0pS+VLozdzZjmIBVCjtDV98PHqqMaJ+NUI+mmnbH040RRWDZt1ldmCNG2iAIBI4iBozlHf2ALU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772576739; c=relaxed/simple;
	bh=R1HAQ8tOaMiEOt5kK9h9/C9h7dlCe1smN0KV5HnTZnU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=l6H6WT/p/DGyfMnatM+2KNWVmHPQzFZvh3ofi9vhG7y9Y2gUdtgsOomSkTF3eivsbYASzgIoKO9czh2VSnn/0or1KEdBgn8Pp1eeLnkuVbpc5ja/fNvd6i7gRbNFkMAJCkLpM8fotLYBN3ZRTl3d2I1HLPibqq1cu3+VCEB5eUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d1936b8a7cso64953198a34.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 Mar 2026 14:25:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772576737; x=1773181537;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YK8nF5otq6OTnx7MCvL13umCbq/pEEflUxPrfJ/I3zo=;
        b=IxibhRthAgHODOF82Za2sxI4UFKRIx68G8CyBHdDwaNY7tW3ghQOC/8Ob6F9UaQmQX
         IIPnXTcTcc1JL4fWZ0ThFxnD7/7j35IzYcpf4Flpg/7MQMEcVHyrxEtmV0mi9rmLE7NU
         AGg9Jn1c4apjvjf2UIeXuCOIg2BKqt/vaFwPTT+nuyBxBoJemipzdxKPHpyHjwbO0m/5
         keCuHiy4lrQ0pNzkHuZxAxfuSydwvr3e6t1lINuEdFQTgVjAFrd/i1OXvmHRfm9WmMCM
         Op63eeaZ45+FJ4A4uJ9HZ0aJZ6I+Pt4b0KDlAPrvNjSo5usTbT2Y/oxy8/OPc8zjT7Qj
         CKMg==
X-Forwarded-Encrypted: i=1; AJvYcCVPHkUQWpNmeYZ0qecmbqSDRXIIG2YgNU3ecXIhXcZpTIio0R7unx+2I61OKnq7aPsNd5VAF66GAh9aVjib@vger.kernel.org
X-Gm-Message-State: AOJu0YydQAepCM/h07LptZr4UBA6sWVC4OSFnqBh/kQS6KLhRBpE00Q6
	n1S87tE0du9nhq5oY2ZoQ7ic4+SUzkeIDDIO9F7zkgmH7hlWAe49xhXPb2yARkZdQSBDrgLqVa1
	KeYfbiSr6qQbMvYwYkJviDB4EdjFtpu/LKyjYvtdMRv692L3fUsDo3W8U/jY=
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:308c:b0:663:d21:9f0 with SMTP id
 006d021491bc7-67b17703df6mr66554eaf.34.1772576737438; Tue, 03 Mar 2026
 14:25:37 -0800 (PST)
Date: Tue, 03 Mar 2026 14:25:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
Subject: [syzbot] [fscrypt?] [f2fs?] memory leak in fscrypt_setup_filename
From: syzbot <syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com>
To: chao@kernel.org, ebiggers@kernel.org, jaegeuk@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0D7F01F7F66
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-1486-lists,linux-fscrypt=lfdr.de,cf7946ab25b21abc4b66];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goo.gl:url,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,appspotmail.com:email,googlegroups.com:email,storage.googleapis.com:url]
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    af4e9ef3d784 uaccess: Fix scoped_user_read_access() for 'p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12506d5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cf7946ab25b21abc4b66
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160a18d6580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e2b0ba580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/70cb2ebe1e6e/disk-af4e9ef3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/945fea3c8a6d/vmlinux-af4e9ef3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa6a6a5cbcc8/bzImage-af4e9ef3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c12ae92fa9b6/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=10e1d202580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888127f70830 (size 16):
  comm "syz.0.23", pid 6144, jiffies 4294943712
  hex dump (first 16 bytes):
    3c af 57 72 5b e6 8f ad 6e 8e fd 33 42 39 03 ff  <.Wr[...n..3B9..
  backtrace (crc 925f8a80):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    fscrypt_setup_filename+0x15e/0x3b0 fs/crypto/fname.c:364
    f2fs_setup_filename+0x52/0xb0 fs/f2fs/dir.c:143
    f2fs_rename+0x159/0xca0 fs/f2fs/namei.c:961
    f2fs_rename2+0xd5/0xf20 fs/f2fs/namei.c:1308
    vfs_rename+0x7ff/0x1250 fs/namei.c:6026
    filename_renameat2+0x4f4/0x660 fs/namei.c:6144
    __do_sys_renameat2 fs/namei.c:6173 [inline]
    __se_sys_renameat2 fs/namei.c:6168 [inline]
    __x64_sys_renameat2+0x59/0x80 fs/namei.c:6168
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

