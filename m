Return-Path: <linux-fscrypt+bounces-1543-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YB8dJ6d2yGmsmQUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1543-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 29 Mar 2026 01:47:35 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B7B35060F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 29 Mar 2026 01:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 986EF3013D5E
	for <lists+linux-fscrypt@lfdr.de>; Sun, 29 Mar 2026 00:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A1F278779;
	Sun, 29 Mar 2026 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XcQyhQ8H"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1BC26FA6F
	for <linux-fscrypt@vger.kernel.org>; Sun, 29 Mar 2026 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774745060; cv=none; b=cwY05XLSInqre2ihny8o9yZyT2IROcPLngZB3+74hdTsQ3AQybgniZgiR5eFGJGxnSbEu69ZPq8j9P0/vAw8p7OyFiGCXxZQ624Q84+qA7UjcKZg62MAcxL+7DQac5fE7cbB0iMErlIuZppI+jRW3Jnh/yZcdnao+DPbBuDUzbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774745060; c=relaxed/simple;
	bh=k1+6R345wxlDBD67g44Gm9ljpIznN0PlZTwor9qiw7Y=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=ZZn/u9Sy+TKbnI2THLpSjZ36kamKzVIOgEETMiKymXNjGfVYLixomLpDY0fBOxkvOnkB8e3YdryNMzs2QRirhQ+NoREnoOWSykpTbI+VqViTq6UtTm4vhLDWjur0ZdMHsM6iCvpXOmuwMwlzrX+59/17EIu4WpQhGXe5/qA8gYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XcQyhQ8H; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-506aa685d62so18047421cf.0
        for <linux-fscrypt@vger.kernel.org>; Sat, 28 Mar 2026 17:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774745058; x=1775349858; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iqMfJl5/lFa18VNuT8wPzE4o/GJyLPfe5qGT4pUdcno=;
        b=XcQyhQ8HrZoaTHjAkFn4JuDzhVCHLW+DrG+4m0CKim7Zu9YMA7TSfpULc1fOLoKNn2
         mGVFURRc3niAK3CRMD/bDdxl6Zqomig2hBOVylgODYMq083bAlW23TsR2N/3Z/j1X7wI
         Hgj5DaP2rhLDgwjEt7+HOL3zogB/n99y8y/rJ2hk1pR4kyiY+6ap3TSImICEwOz8cY0s
         0S3zj846km0XqkytdQ5horSJsU23ufxsCwkrieVd8Lc9dYypZvlIGEOcsWFH4cmY89qT
         rw9yxEnQNOGwoA9lXlF7869b2YDw+UbqcS7gikBlH0jr0zY9aeGPogFfVg6t9vR2MO8k
         h7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774745058; x=1775349858;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iqMfJl5/lFa18VNuT8wPzE4o/GJyLPfe5qGT4pUdcno=;
        b=kRElHmq+dM2OKFcMVxzf9IBPCQr7fMD9etaGvmurpR0q0KoX8BRvOrQb5ftsdYy6T2
         FFVWb+3VJPk6A4wqbg+cZ7uJ4dgtF1FsEsFJFWCKXCpuWBJQgELXiIeENwah4UZ1pCPd
         b4BY27KDuuEzdCaxdStrhw3ZkAR4npx/N/RPS8r+PL0/oa65itG3ibBym9OKC+oPcNqB
         k4XI3RI3UgztvJCVr71WMWe3FLba+dJLuMTXK3PqoiiQ4v+h6L9O2wByzmu9kITR0jCf
         DAxgFV97uAfl0b1NeXyfk5AdrqjhDbzvvcYnoEDANdN2tOUG+TmgxMN4vplg6jR/NEYf
         M1Pg==
X-Forwarded-Encrypted: i=1; AJvYcCVNkUOtSbca/3PhEjDmoFUDI/9CwXkBp64WV0TdMX/i5hdkgNfZUSVqPBVDBE5YR0ECTkFHsQsCE7cz+WkS@vger.kernel.org
X-Gm-Message-State: AOJu0YzKarDmtp23mdhn8+alrI5ffvSzIWivKSJ8iysvTU/roHZDKf8z
	9feB0y9wB7EPvpHGjci7/UVvB4Ok84e6+wvmixOh9xUZJ4OZMghMOHKD
X-Gm-Gg: ATEYQzzz1gd3W8HHAT7EW0+hHUtIiZkquNggYjJfTsb8ZTXQdHT2j5iLRS6mzxHls3i
	+sqqXWODdYklRulbyliwQXrvhea+tH/kK8CoLFzxr94FBRWrz227TSrRsDwiT51AnxPz2wjdd+0
	lpCk4Vp1ICJ38ljsBXunWeWvbs3JG9A6DhPHa+Yrn/9FMJchq8plDxDY4HEsUNXhquWuT6CMrBK
	MPgrkIGSdyFXn1xjTGNZxIVAW6bBhXBRyXR+AvgNwuS7Pr7526vxb6QOYqnppB5BTFdQCUyyLLH
	fJeclmlPz4A8UdM3S2GoU0jmAkMjeLU8vtKy66eFQXzf/YINajCq7wIiTc7qz5AiA1Gj+RQca1P
	oCBbiAKKR53Fo6Oks8lRpK2VgF514JFUpWeKGuz65cR5WYN4RQFCqO/GOR4wQutN1yiiRueui/z
	XHUxxu5pjMIsveyDf4UheJ6KbDC50CQc9ElFoAd2O6KbitE6yr0OmS+4UoB8GaoVk=
X-Received: by 2002:a05:622a:4d9b:b0:50b:277d:efc9 with SMTP id d75a77b69052e-50ba3918d47mr106097711cf.39.1774745057674;
        Sat, 28 Mar 2026 17:44:17 -0700 (PDT)
Received: from smtpclient.apple ([2601:985:4601:5df0:d133:2d56:2e26:76e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb2c678cfsm29034361cf.2.2026.03.28.17.44.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2026 17:44:17 -0700 (PDT)
From: Shuangpeng <shuangpeng.kernel@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: [BUG] f2fs/fscrypt: KASAN: null-ptr-deref in
 fscrypt_decrypt_pagecache_blocks
Message-Id: <68D594A5-3A3B-41B5-BEEF-1D0CD08D4A18@gmail.com>
Date: Sat, 28 Mar 2026 20:44:05 -0400
Cc: linux-f2fs-devel@lists.sourceforge.net,
 linux-fscrypt@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>
To: chao@kernel.org,
 jaegeuk@kernel.org,
 ebiggers@kernel.org
X-Mailer: Apple Mail (2.3864.400.21)
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1543-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shuangpengkernel@gmail.com,linux-fscrypt@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 07B7B35060F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Kernel Maintainers,

I hit the following KASAN report while testing current upstream kernel:

KASAN: null-ptr-deref in fscrypt_decrypt_pagecache_blocks

on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/4bb5d91db54ee2c654b0ca1f1d2a9b47

I=E2=80=99m happy to test debug patches or provide additional =
information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>


[   85.653245][   T53] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   85.654086][   T53] BUG: KASAN: null-ptr-deref in =
fscrypt_decrypt_pagecache_blocks (fs/crypto/crypto.c:?)
[   85.654989][   T53] Read of size 1 at addr 0000000000000009 by task =
kworker/u13:0/53
[   85.655763][   T53]
[   85.656011][   T53] CPU: 1 UID: 0 PID: 53 Comm: kworker/u13:0 Not =
tainted 7.0.0-rc5-00051-gbbeb83d3182a #38 PREEMPT(full)
[   85.656020][   T53] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
[   85.656026][   T53] Workqueue: f2fs_post_read_wq f2fs_post_read_work
[   85.656039][   T53] Call Trace:
[   85.656044][   T53]  <TASK>
[   85.656047][   T53]  dump_stack_lvl (lib/dump_stack.c:122)
[   85.656057][   T53]  print_report (mm/kasan/report.c:487)
[   85.656095][   T53]  kasan_report (mm/kasan/report.c:597)
[   85.656114][   T53]  fscrypt_decrypt_pagecache_blocks =
(fs/crypto/crypto.c:?)
[   85.656136][   T53]  fscrypt_decrypt_bio (fs/crypto/bio.c:41)
[   85.656190][   T53]  f2fs_post_read_work (fs/f2fs/data.c:297)
[   85.656197][   T53]  process_scheduled_works (kernel/workqueue.c:3281 =
kernel/workqueue.c:3359)
[   85.656209][   T53]  worker_thread (kernel/workqueue.c:?)
[   85.656230][   T53]  kthread (kernel/kthread.c:437)
[   85.656243][   T53]  ret_from_fork (arch/x86/kernel/process.c:164)
[   85.656279][   T53]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   85.656291][   T53]  </TASK>
[   85.656294][   T53] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Best,
Shuangpeng


