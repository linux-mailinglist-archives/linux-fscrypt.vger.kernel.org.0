Return-Path: <linux-fscrypt+bounces-885-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D763C1B0BC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 15:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CA12627A07
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 13:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768982E1EE7;
	Wed, 29 Oct 2025 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFYPr0VJ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAC42E1C5C
	for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761743193; cv=none; b=hpClwA2JnnGnhvCgDqqwg/ffGhSVF25TXrDRw64jvGOR/YWoF7bD6UKz98gIAlk8lceW7wQAEVSQwWwlctPQSYoHpIhG8jKMw4pKZxiO2IuRtLBAHUgUQE0iWx1UoSq0Gd2IRU+ieYDN4jI2BrJUDNZfGvHUU30i0G0MmQl552c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761743193; c=relaxed/simple;
	bh=6BClPQUdxG10zjBdmHGDPaxdKyrNyxZpCgTbYkLgMYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uzr4N1uMy3Au80pesilpSHR5XfF3th8Om6pasAzgF6ZaiTQ1e0KEK37jqnNUgOB32FjelHcakfCBUtJerOowLho+JeAJLXx4VbF4qm2/k+6SiLNW9wyC5MdVeY9230sTF+ihGzijOSKRKYcVxJ8DbW/PDzRqYb583C/SXDD8b2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VFYPr0VJ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b553412a19bso4757928a12.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 06:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761743191; x=1762347991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VOT5jsIFIEY+PSkou/HWnBjc+7PMFp9eDj2ahUEYiEQ=;
        b=VFYPr0VJ2bDhXJdleb89zL9Bm8sPEMJACBhb+U5nFn2Mm7vg7Rh4Igwh+wnZOXn9tR
         vGUVM2kXV2z5lfE6hL0n0Cc7Uhn878yC/HRcBqNns3bR+VgOdfdz2RDRQOcNoohteXcY
         IbP9eNfkAMqmrFeyZfgba+xaFjEorPQ/SUjenTSIQZum87YYL5rc2xhKTgUb1h4XqEOd
         hioymwxA+lbGQnlUqWbhvejk67i6s2xjiEu+0cU5OZrtNIW5luvsHmTD31A2tM04AmB9
         FI4swqchW01FUwDapiC8sRtEdMvSFI35gDlTteTETuRnSZmIK+edIKF7p68IR7Fkr8m3
         B7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761743191; x=1762347991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VOT5jsIFIEY+PSkou/HWnBjc+7PMFp9eDj2ahUEYiEQ=;
        b=AOcAmEwyO8c0gdJIVU6bzNIOAWUTDAVeNVyNE7ZVY0eTCFQ3RnAylIJ6az+KnVDoJU
         ytBeGUQF/3oXqBTsW+YU0G4PARMDkTBOmhbPTEwDT4fGoUsoaHHHPhCxQ7ffM4L52pa3
         zdSMSUBxTxZgv61PQ3a3afs7wF5p6SR3wUwf8rjZc0ZWnANCBlEXHFGk0KEm0Yyovqoi
         /eV82w48NHlh39jiXVI3VYTsXSueTbqjCFut9F2MuRXUMUmzPbxR1Fu5ca9TXmjcayXH
         8T6uNW+Q1ve2M//Kx4h99l6xGLfeHh36Tmpev7OAEjtRmALxDxVkii/YmnpsD08BrtpQ
         UBKQ==
X-Gm-Message-State: AOJu0Yz5L4OAG0ilTwNkMY2evn6CRS/nxMK1iuxQ/O2UZjG45x3V1TWL
	0R/V9VBatzuQ+hCorb7gMGP9bK3HANuR4FjCxsNitRe+Lfnc1ZYcgNrb
X-Gm-Gg: ASbGnctb+Z9qABM1sgykQjlV42NkwpPQSPLR2oXFnmsiXvJ9Apx4L9pwdp8Bsxaa1oG
	yCJOXdwioQ2grQW0l5ff/lhG1frKjKobhlcJy/yyaMVyjbMbTx2Rx+HS4XTw7Pwmp59JYZlEiM8
	bFDJ9UPpx1QtcS+3TShN24LAiXyDHcv+I+bsSOY7HvrBR3hQBrCKhhR9mNC2Q0u7hiuCEKWM2lJ
	+R9yXh2vrMTqk1QbmcP6m7oSjdk6GxucZye+/ytcHejt1pLdjVjDXz+VmzXu2pbyLY4Tdr+mevJ
	LToGVYX6TRd0EB3yw6HGhtcFpqmNVVxRgKLZ98u+eTEb4PZzAmGcyp5PjolH1JjJAAHIfGH4acD
	cm+0Y0duZmeqlymcNC2tnHRYlSffIAI6BJBI6qP+LjPJ5Z3eTWDRkcQNEZg/VrzvlZx+6l5vl8D
	tN1bu9K/sgJH7bIPru4I/QPa1zyfsC4xp3ucTiFhHcl0d05DISIaYBNZLtdw==
X-Google-Smtp-Source: AGHT+IHtXvIOr24JMtL62BUiiD4tB9aS3Ud1LD8uSpg2cJFqIH7SD9Gdz6gc5ZcdhLkIOIjLkEAQNw==
X-Received: by 2002:a17:902:d2ce:b0:25c:ae94:f49e with SMTP id d9443c01a7336-294deec4d7dmr36639125ad.37.1761743190733;
        Wed, 29 Oct 2025 06:06:30 -0700 (PDT)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-294e3ae4ba2sm20776815ad.40.2025.10.29.06.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 06:06:30 -0700 (PDT)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Cc: linux-fscrypt@vger.kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH] fscrypt: fix left shift underflow when inode->i_blkbits > PAGE_SHIFT
Date: Wed, 29 Oct 2025 21:06:08 +0800
Message-ID: <20251029130608.331477-1-yangyongpeng.storage@gmail.com>
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

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
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


