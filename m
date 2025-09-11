Return-Path: <linux-fscrypt+bounces-809-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5592B529EE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70C725812BD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF05269B0D;
	Thu, 11 Sep 2025 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="zgp44XFw"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5211622D4F1
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575780; cv=none; b=Ws2E8p0OzfbrPoQh0AkToIsN/1aw27TB2uJb4LVAYx6Yjb5dIMpq65BKe/M/XJkv1opyI1isgoDcsAtuN4X5XV0TXbC507bwC1BZaNDIjSLPk9RAuoue65cSGUjx7g5C32/yEs5O9S7938fwhvZTgLDC+Wl4pW5HIHAJA+gBr4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575780; c=relaxed/simple;
	bh=dzyPDAyBY3iE453hKGZWh2GhozhS+rLJS+JK8T73SRs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eAmkK17HroHIUnBX0aKGgdS5WK5MtBgkQsX7QbFDnycCXLDnb2JlfCOuYFkp95xugxzSCNVLQ/whm1fvK6Px0tOi1nhmbNgTtLN4is+YYNvJTfwogpDc4nskvJhruhQo7C+P5orn+S5G13/pp4wq8jCy0lwsy/i0fyPtEgxA5aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=zgp44XFw; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24af8cd99ddso5630245ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575777; x=1758180577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D81Vt79I/BTOBBePW6+0X1oh6zDyKaYVMRC1TVaQyRM=;
        b=zgp44XFwPbkb7o2cKpnE2r7Xs7lyjr3cY0QI3HrjgdAMbh33t/+5pXXQkW2WYVI5k4
         gh9OK4ITqPQEKt272Qe5ZGfLR1PhrTkWsnMwPRx9vexHj3RpxsXU6/oWTg3QH12gPJd6
         dq9lK3cBKwbcf2ypExkbHjSOxcRvzRuTcFPWLJZ21iUtqgYS22oPWVB9vl8UXiyVQInD
         MlcHyJKYUXz7hr9V4wKVU3sRkvF6h8HgWlfPLLWFJb1OCPkYruVQNudDBIzLwkwNBAi6
         9Oh57zk/RWXKrzNKhXLii6F4JOjfsMqdG9ETPmPx71gVAwGkHkmKGHAQHgzh2XUo+25j
         ZJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575777; x=1758180577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D81Vt79I/BTOBBePW6+0X1oh6zDyKaYVMRC1TVaQyRM=;
        b=vDnBw5G7+SPJ1d6P7hjiq2gMlCb5G4bH75lglfTYfd/5xRUBqT5Yf456dXUecn45EH
         ZkSm2I6Evqn+/Y7hOEsqJspip3refEDFGo+xfvGn1bsEDF2zSgLmePFmtPafxKncRq+f
         NtpN38IQT85GVU0mKXOzEdH+LO2WN0VuRTCA+Y31lvdlRY0sww13wevA/d0PISLeGubW
         Of4kc1wkZ/bBEhy193R4rgDnc3egg93WWLG1c55/agg+TZ1vy3FO6t9WIaul6mNAqoER
         4D+T70A2U7kzA4cutA2IxJEFc9tp1ZXon04Xd5O1S9cglvEKcl1xDttmmS/IC2j4FtB5
         EhVA==
X-Forwarded-Encrypted: i=1; AJvYcCVYjyXRg/cv9xY7VjwlHcesCHqBw1sUtdu3VnONhLgpc17IAPPoIG9LvBcu0ITDDqeqkIB6oyMc78JWP2mt@vger.kernel.org
X-Gm-Message-State: AOJu0YwmV6Y1DJbA2lqfKhFX3JdzZ+p6xDlPx5eLx7eJp2LwUN8hsDI7
	yAl6QzRnDIzYN8ZFbxW6pCpyIkozmpaCLSfehrEOwm0TRMs5sploP3KpiFdOCgfZlTg=
X-Gm-Gg: ASbGncvJ7atYnyUIfIOHoAtni6ZipS8S0gOiWJwhEV4XQ++b1I6RIUz7XIkBBcEdBrT
	b5h8/2oHBOhykbGoVhgbDnxyTchA6F3zy9ImSfHzsDrvc1gIly2OXIyQ+FTD2GYmCghaMRyadU0
	l0EkUh2ygF0+Sc7Q9fnU/DJVc/gXGzKgiI7HtlCorlQEZf2V8kYuWhH17qRX5JdotUlcWchXORD
	H0Y86OCVD6Tr4itpmaAhcAsyzCYABAfEb+LENkD1+qa4rrClsTD+nfdATMZe1uIG7hfZ9VLqb40
	Wd+Fkx2+9TKyp7u/PRI1UoiOzvei6RbB2oaMxc4VUYTA5pZxGycRDJi01V21iqOVXPfvH0ZteFN
	W2J6h0CrZUW9xcK8og5MmQkvY1ju19Zg29tABa5vy1Z/APwSOrxeQMkPaCg==
X-Google-Smtp-Source: AGHT+IHO7xlf6/5dPDqWynFAANB+M0UuBkmme6pcsf85zd3+cmkflA/c+A0enwc+u10nZW1Fv/oP5w==
X-Received: by 2002:a17:903:1111:b0:251:3d1c:81f4 with SMTP id d9443c01a7336-25173bbbab1mr288649825ad.54.1757575777526;
        Thu, 11 Sep 2025 00:29:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37293ef1sm9838395ad.41.2025.09.11.00.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:29:36 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	akpm@linux-foundation.org
Cc: visitorckw@gmail.com,
	home7438072@gmail.com,
	409411716@gms.tku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 0/5] lib/base64: add generic encoder/decoder, migrate users
Date: Thu, 11 Sep 2025 15:29:25 +0800
Message-Id: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a generic, customizable Base64 encoder/decoder to
the kernel library, eliminating duplicated implementations and delivering
significant performance improvements.

The new helpers support a caller-supplied 64-character table and optional
'=' padding, covering existing variants such as base64url (fscrypt) and
Ceph's custom alphabet. As part of this series, both fscrypt and Ceph are
migrated to the generic helpers, removing their local routines while
preserving their specific formats.

On the encoder side, the implementation operates on 3-byte input blocks
mapped directly to 4 output symbols, avoiding bit-by-bit streaming. This
reduces shifts, masks, and loop overhead, achieving up to ~2.7x speedup
over previous implementations while remaining fully RFC 4648-compatible.

On the decoder side, optimizations replace strchr()-based lookups with a
direct mapping table. Together with stricter RFC 4648 validation, this
yields a ~12-15x improvement in decode throughput.

Overall, the series improves maintainability, correctness, and
performance of Base64 handling across the kernel.

Note:
  - The included KUnit patch provides correctness and performance
    comparison tests to help reviewers validate the improvements. All
    tests pass locally on x86_64 (KTAP: pass:3 fail:0 skip:0). Benchmark
    numbers are informational only and do not gate the tests.
  - Updates nvme-auth call sites to the new API.

Thanks,
Guan-Chun Wu

---

v1 -> v2:
  - Add a KUnit test suite for lib/base64:
      * correctness tests (multiple alphabets, with/without padding)
      * simple microbenchmark for informational performance comparison
  - Rework encoder/decoder:
      * encoder: generalize to a caller-provided 64-character table and
        optional '=' padding
      * decoder: optimize and extend to generic tables
  - fscrypt: migrate from local base64url helpers to generic lib/base64
  - ceph: migrate from local base64 helpers to generic lib/base64

---

Guan-Chun Wu (4):
  lib/base64: rework encoder/decoder with customizable support and
    update nvme-auth
  lib: add KUnit tests for base64 encoding/decoding
  fscrypt: replace local base64url helpers with generic lib/base64
    helpers
  ceph: replace local base64 encode/decode with generic lib/base64
    helpers

Kuan-Wei Chiu (1):
  lib/base64: Replace strchr() for better performance

 drivers/nvme/common/auth.c |   7 +-
 fs/ceph/crypto.c           |  53 +-------
 fs/ceph/crypto.h           |   6 +-
 fs/ceph/dir.c              |   5 +-
 fs/ceph/inode.c            |   2 +-
 fs/crypto/fname.c          |  86 +------------
 include/linux/base64.h     |   4 +-
 lib/Kconfig.debug          |  19 ++-
 lib/base64.c               | 239 ++++++++++++++++++++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 230 +++++++++++++++++++++++++++++++++++
 11 files changed, 466 insertions(+), 186 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1


