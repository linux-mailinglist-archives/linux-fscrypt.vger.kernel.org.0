Return-Path: <linux-fscrypt+bounces-888-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B62C1EC2A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Oct 2025 08:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E85E406990
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Oct 2025 07:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E497D37A3C6;
	Thu, 30 Oct 2025 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1EkTT7F"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462962848B2
	for <linux-fscrypt@vger.kernel.org>; Thu, 30 Oct 2025 07:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809427; cv=none; b=fayH1L01/n330qpf9Up6oh1FXhFnWEwrjy1W/vZhLnW2PvfuNsQLxSbHJBcZnsE/26aBKO0DWoprj8oT5WpDSsx3K4i1tkpQ9vY+3SAUpiiLL2icvSSWYfRhDh9CUr+BPpmuXlmwJxmp8tJ+XXahBay1XS1ppVWP6fqXD6cER3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809427; c=relaxed/simple;
	bh=a5R88igvUjSxLAteMKqQkUmrVIFPpBGsuXIiRJYqrWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jGPn8lAWaV+xp220FsWhEhLHQt+kbDjS60bxEjusPgUfpVtU6EOsaROasmOQ8NB8m4XGlzTDmawLZtAKH3ZKkRU6nlku/veqIqPcHFxtQBETgZLbBhW030z/QjSxQ56weAkwTcRQ/f6JDOckPO0J+Scoc2uIyY/+3xGj6+5cs3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1EkTT7F; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-330b4739538so769767a91.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Oct 2025 00:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761809426; x=1762414226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kYwYZd/08wrCzXftB0pk8cwMPIhXKx1ChtdBmlsP5ZA=;
        b=N1EkTT7F9lv1YCi5rqgcomaLwjVk3ucqA32rkV6mN+xIhxsRW+PuoW/k+iCys5rNjJ
         ew/yXT7dBmO3TzK2BcyywZz2nknMk1nFQ1qBs6Xb79GSAg7YOoVFSil1t+TnPomB9cn8
         BKp5Vik79D/4PzXbEetoGOeYJFgo240c+t762ynLQvY70CWFnq9KmNXY4wHwa5JTUhPn
         W1gH6OQwVgYOuhnJKvOFUmtO/HtVe9NqY1bSSiyFksvEZMDwR3082bmpGsisG9H9cYzY
         j8LzK5qkkg3IT1XbH078n4LR1hcMtTpRdqZWP6auc9dGhchVFxTeWSel88/cQ+BuYd/H
         yC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761809426; x=1762414226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYwYZd/08wrCzXftB0pk8cwMPIhXKx1ChtdBmlsP5ZA=;
        b=AZm4Sl57ROKKHbiWQM902co8iUZmntMCXGx5dYNl45GLDfql0UzMrZklUsIukhp2LW
         4XZ1VblV68qqWxCvy20Y7lHrpU7bWkuiEQW8P09NcaT4lIokJpmZluyIbHkBUFqaCWQm
         ZzcFFH/kz6Eh0OM0gTT4lUu6st+MRf2ZjLClIE8CS2bG8JT4Wg7/csBJYEEDFE+6f4CR
         Is40KkQfXa9jC/92outev3tTjh+lJZVPBU/GyxGh1nBQ7BTpjkfRVBELTq+e+MzsrJUK
         qF0J1r57cC3RMqW7lt4tVxVIobhHqPcNjMZR5zJFsjMRcD0CX7uDwff3Kmn3ZGztuLA9
         bvIQ==
X-Gm-Message-State: AOJu0YwNxc4PnYkNib6iWLDymUY5mSdKsAXG8VdHDlTZBbpPjJTWZ4WP
	UgqML9nMD5GwIUlhhw93dQen8vsoKcmvoCmjIK9vegXh+wzOoN1PDqGb
X-Gm-Gg: ASbGncsWd009youcFJxWJcC61MJiN8MwEcvRqW+l6lPoAFGKpZxZ+huhWNv0HnPmXyu
	1OiTmzHfll/tz+Sbcdox+06YZOs7gemJ5uXhRk5wKIcsUjJbr/nffIGeFNK3gK5bOvX+m1bcvHR
	fFuSsNn4pmdaD9P80HTxp3njlKrAjHTfzBmygCkigDEccje8lYOeGDYd2lu6/82yU3HS9SVYE1j
	eDDeRmMBQyFs85rjlh/wLCSGGtyWSwB66rR8Hg4qyrhQED/lwgKZBZEFyt1kQv0haJ2/IneSfGP
	UPwV1kLH6rXK93UY46GHoQJc7qVJctuOq6xouIfULc9VGidCEPIjD2kgwMppWi47xYZwFBL5GYT
	7goWdCfhkuw/0CEA7rQ6s49OHosGdwRW0kyjePwD9c40L1fYGzYgl8SxAMB8JAMvhl/bb9Ovgiv
	gOSw5SjZPqamCVSR5l0KCO8ivc6fgQ/O8vdcnobfa7CUL5eeA=
X-Google-Smtp-Source: AGHT+IGaSgFqArQM1JobxBml2OJEOQF5Cs1TN+ePkY7B+Slu6XODl8J0MuraoMgvbahMijOeCXzlhg==
X-Received: by 2002:a17:90b:1a85:b0:33e:2d0f:479b with SMTP id 98e67ed59e1d1-3403a141952mr7070950a91.6.1761809425468;
        Thu, 30 Oct 2025 00:30:25 -0700 (PDT)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34050980be1sm1521673a91.2.2025.10.30.00.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 00:30:25 -0700 (PDT)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Cc: linux-fscrypt@vger.kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH v2] fscrypt: fix left shift underflow when inode->i_blkbits > PAGE_SHIFT
Date: Thu, 30 Oct 2025 15:29:56 +0800
Message-ID: <20251030072956.454679-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

When simulating an nvme device on qemu with both logical_block_size and
physical_block_size set to 8 KiB, a error trace appears during partition
table reading at boot time. The issue is caused by inode->i_blkbits being
larger than PAGE_SHIFT, which leads to a left shift of -1 and triggering a
UBSAN warning.

[    2.697306] ------------[ cut here ]------------
[    2.697309] UBSAN: shift-out-of-bounds in fs/crypto/inline_crypt.c:336:37
[    2.697311] shift exponent -1 is negative
[    2.697315] CPU: 3 UID: 0 PID: 274 Comm: (udev-worker) Not tainted 6.18.0-rc2+ #34 PREEMPT(voluntary)
[    2.697317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    2.697320] Call Trace:
[    2.697324]  <TASK>
[    2.697325]  dump_stack_lvl+0x76/0xa0
[    2.697340]  dump_stack+0x10/0x20
[    2.697342]  __ubsan_handle_shift_out_of_bounds+0x1e3/0x390
[    2.697351]  bh_get_inode_and_lblk_num.cold+0x12/0x94
[    2.697359]  fscrypt_set_bio_crypt_ctx_bh+0x44/0x90
[    2.697365]  submit_bh_wbc+0xb6/0x190
[    2.697370]  block_read_full_folio+0x194/0x270
[    2.697371]  ? __pfx_blkdev_get_block+0x10/0x10
[    2.697375]  ? __pfx_blkdev_read_folio+0x10/0x10
[    2.697377]  blkdev_read_folio+0x18/0x30
[    2.697379]  filemap_read_folio+0x40/0xe0
[    2.697382]  filemap_get_pages+0x5ef/0x7a0
[    2.697385]  ? mmap_region+0x63/0xd0
[    2.697389]  filemap_read+0x11d/0x520
[    2.697392]  blkdev_read_iter+0x7c/0x180
[    2.697393]  vfs_read+0x261/0x390
[    2.697397]  ksys_read+0x71/0xf0
[    2.697398]  __x64_sys_read+0x19/0x30
[    2.697399]  x64_sys_call+0x1e88/0x26a0
[    2.697405]  do_syscall_64+0x80/0x670
[    2.697410]  ? __x64_sys_newfstat+0x15/0x20
[    2.697414]  ? x64_sys_call+0x204a/0x26a0
[    2.697415]  ? do_syscall_64+0xb8/0x670
[    2.697417]  ? irqentry_exit_to_user_mode+0x2e/0x2a0
[    2.697420]  ? irqentry_exit+0x43/0x50
[    2.697421]  ? exc_page_fault+0x90/0x1b0
[    2.697422]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    2.697425] RIP: 0033:0x75054cba4a06
[    2.697426] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08
[    2.697427] RSP: 002b:00007fff973723a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
[    2.697430] RAX: ffffffffffffffda RBX: 00005ea9a2c02760 RCX: 000075054cba4a06
[    2.697432] RDX: 0000000000002000 RSI: 000075054c190000 RDI: 000000000000001b
[    2.697433] RBP: 00007fff973723c0 R08: 0000000000000000 R09: 0000000000000000
[    2.697434] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[    2.697434] R13: 00005ea9a2c027c0 R14: 00005ea9a2be5608 R15: 00005ea9a2be55f0
[    2.697436]  </TASK>
[    2.697436] ---[ end trace ]---

This situation can happen for block devices because when
CONFIG_TRANSPARENT_HUGEPAGE is enabled, the maximum logical_block_size
is 64 KiB. set_init_blocksize() then sets the block device inode->i_blkbits
to 8 KiB, which is within this limit.

File I/O does not trigger this problem because for filesystems that do not
support the FS_LBS feature, sb_set_blocksize() prevents sb->s_blocksize_bits
from being larger than PAGE_SHIFT. During inode allocation,
alloc_inode()->inode_init_always() assigns inode->i_blkbits from
sb->s_blocksize_bits. Currently, only xfs_fs_type has the FS_LBS flag, and
since xfs I/O paths do not reach submit_bh_wbc(), it does not hit the
left-shift underflow issue.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
v2:
- Added more explanations about the issue in the commit message.
---
 fs/crypto/inline_crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 5dee7c498bc8..6beb5f490612 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -333,7 +333,7 @@ static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
 	inode = mapping->host;
 
 	*inode_ret = inode;
-	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
+	*lblk_num_ret = (((u64)folio->index << PAGE_SHIFT) >> inode->i_blkbits) +
 			(bh_offset(bh) >> inode->i_blkbits);
 	return true;
 }
-- 
2.43.0


