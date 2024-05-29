Return-Path: <linux-fscrypt+bounces-285-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0118D3FBA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 May 2024 22:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A10B1C216FC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 May 2024 20:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937261C8FA5;
	Wed, 29 May 2024 20:41:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7791C68AB
	for <linux-fscrypt@vger.kernel.org>; Wed, 29 May 2024 20:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717015281; cv=none; b=s42QHXnJmk7ZEHV9V0yas+nAioQkGBewneXsPZbCZmac7KhrppwVb5QjZnKUBOWERP07zCbUlY6bSVYTvb/zAkqa3C0ujI6GN9jRZ85mvmHvWkB3NGJtmEpvCoHEhOZdbXgX+W0iQFcZPRUzBcJXTfnY1PKlZIf3VBx7bQdqZPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717015281; c=relaxed/simple;
	bh=vNUZSXvhfyZXrV1PqvZgY4bk+8fmC2eOIfBDamZztuU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sxvs64h473kxXre4aYFp9CmQRbEJqdKwGlMXLr3T+Co1Fr6bt1IIMl0GIeAzT3co5u/Vz3n8kqGAzdfBgwZQUV6T+Y0iKyYBSjp6kFkkMZ/jgrPyJtbD6TyMQYndFWpk+Lm3lvAhwiSzL+ODf+KavbJA8QcyQmppDPUU9mGrRdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7eac412397cso13245739f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 May 2024 13:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717015279; x=1717620079;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i+7TQmH1QD5ycywdTyCtsUi/9cznvI6RRnPmBYeGhNY=;
        b=bWMGiy8npgw9g0hfJd/8B81EBK7PEHDCBVXoO7XVFJj3aPPj8ncmqslVzA5CVs0xHH
         NVTFDVlpAzPRTpxVolWPua+0K7/4QH9TTe3dNiKNK0Z6oHmHJtr8DtWJocDjUEX4X4sF
         FEUPKL1XQ2EYNRHkYFRehPRu95g4z8+RTvx9FH4uNzo4k5kogak18+5leoklGiF3TlOn
         dVdBX8I8bNDY2nTP7CYjX0x3kORBm3RSRNIwGZMTNkndWvdvM5YGOSctH3YREg0uiKUF
         qg/eMWbnNMdoZeeHFR/U3IOx6UV9288+hQ45o43MgbaT2i5V01HKGNosbNZFP1yzF9uG
         9rLw==
X-Forwarded-Encrypted: i=1; AJvYcCVYbzaJArdr++yesLU41Tpqytgb/9J6KBgjzuRvaywwAMDD1bXX1Z4sfGda9iz/bT2+wZBuRt1LyipSTZsPWvyogS6WyAHDGYv7ThOAhw==
X-Gm-Message-State: AOJu0Yz+NsgeRMCmgjs8ueio9IB+GKnjWdAf0IgsnnQSVFRZom105Us+
	kTWH1cPsjfE3Y577LXjV0DBf8ouQCvRx0Aj9BuowCHdo+NyAzZnpCSGLQRvUR7zBvOvcTSG3ifR
	Bg3i2ogIyKWiY1hz3Dtiyfs19Nh6I0PCS3/8sW8gI4f1rGWNSWix+LnE=
X-Google-Smtp-Source: AGHT+IH+6tmCLu8pIgw/Dhplloi6SKh6Te/gU9fAy8vAXL0utPay12W/fDdNdhOPP1pL+7B7RfrRmJyqoHkqnICkuwTB05+ikb2e
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3412:b0:7da:6916:b435 with SMTP id
 ca18e2360f4ac-7eaf5b67173mr259439f.0.1717015279272; Wed, 29 May 2024 13:41:19
 -0700 (PDT)
Date: Wed, 29 May 2024 13:41:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb987006199dc574@google.com>
Subject: [syzbot] [fscrypt?] WARNING in fscrypt_fname_siphash
From: syzbot <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, ebiggers@kernel.org, 
	fw@strlen.de, jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    74eca356f6d4 Merge tag 'ceph-for-6.10-rc1' of https://gith..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15460752980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee7b962709a5f5a5
dashboard link: https://syzkaller.appspot.com/bug?extid=340581ba9dceb7e06fb3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15da8cd8980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14111972980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a5f8df213fa4/disk-74eca356.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/864334770567/vmlinux-74eca356.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b30965ded6d8/bzImage-74eca356.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b77754f322c2/mount_0.gz

The issue was bisected to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dc9ee8980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11dc9ee8980000
console output: https://syzkaller.appspot.com/x/log.txt?x=16dc9ee8980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
fscrypt: AES-256-CBC-CTS using implementation "cts-cbc-aes-aesni"
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5079 at fs/crypto/fname.c:567 fscrypt_fname_siphash+0xc2/0x100 fs/crypto/fname.c:567
Modules linked in:
CPU: 1 PID: 5079 Comm: syz-executor422 Not tainted 6.9.0-syzkaller-12358-g74eca356f6d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:fscrypt_fname_siphash+0xc2/0x100 fs/crypto/fname.c:567
Code: 0f b6 04 28 84 c0 75 3d 41 8b 34 24 49 83 c6 40 4c 89 ff 4c 89 f2 5b 41 5c 41 5d 41 5e 41 5f e9 b4 97 52 09 e8 3f 7a 72 ff 90 <0f> 0b 90 eb a8 89 d9 80 e1 07 38 c1 7c 86 48 89 df e8 d8 f0 d4 ff
RSP: 0018:ffffc90003c7f430 EFLAGS: 00010293
RAX: ffffffff822399b1 RBX: 0000000000000000 RCX: ffff888022a61e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003c7f5f0 R08: ffffffff82239955 R09: ffffffff82541c38
R10: 0000000000000007 R11: ffff888022a61e00 R12: ffffc90003c7f580
R13: dffffc0000000000 R14: ffff88807fcb3000 R15: ffff88807fd0b4b0
FS:  000055558ddca380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045ede0 CR3: 0000000074e92000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ext4fs_dirhash+0x3db/0x1530 fs/ext4/hash.c:268
 ext4fs_dirhash+0x193/0x320 fs/ext4/hash.c:322
 htree_dirblock_to_tree+0x727/0x10e0 fs/ext4/namei.c:1124
 ext4_htree_fill_tree+0x744/0x1400 fs/ext4/namei.c:1219
 ext4_dx_readdir fs/ext4/dir.c:597 [inline]
 ext4_readdir+0x2b1c/0x3500 fs/ext4/dir.c:142
 iterate_dir+0x65e/0x820 fs/readdir.c:110
 __do_sys_getdents64 fs/readdir.c:409 [inline]
 __se_sys_getdents64+0x20d/0x4f0 fs/readdir.c:394
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f91a3441b99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd41154a58 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 6f72746e6f632f2e RCX: 00007f91a3441b99
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f91a34b55f0 R08: 000055558ddcb4c0 R09: 000055558ddcb4c0
R10: 000055558ddcb4c0 R11: 0000000000000246 R12: 00007ffd41154a80
R13: 00007ffd41154ca8 R14: 431bde82d7b634db R15: 00007f91a348a03b
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

