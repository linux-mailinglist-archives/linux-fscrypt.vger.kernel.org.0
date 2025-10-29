Return-Path: <linux-fscrypt+bounces-878-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A662C19A40
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 11:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85CAA46046B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 10:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59792F60A3;
	Wed, 29 Oct 2025 10:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="2NchK2zG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F152F5A1B
	for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 10:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733095; cv=none; b=KoVHpjaa0kSqgPJnv18yuiXJuh3XzQVYgzgJh6ib1XTQ8Cz1DljbAZVO4mLETG5oxSDFgcaIPUd+Z9cg0xPcqicbnjFDB/mpaf+1oVBbr4VbzCJdUFt8xR5mai9r50blwoEkOZlkzCWVMZRZq+mqM3fvcGNWLsGfW6dQOjmsGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733095; c=relaxed/simple;
	bh=QssEUbUYx0izMJIUmHudPbCRzHZCBlewAEJ42z/4KAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FmddBqqAM4NOAWcloB/59cS40ynwJ1f4Im9BTJcvS85GQcbL63X2J3fcqEcRSXAdGSxKRFkojq1dXNccSGUW/g8Ya8uQlCC4KyllAtkA7EzqT9IkPD+p9w5FaG7cC+1+5MEYtjICnJcZUaLQtmyW7YRO1zsXkG98a6vzg2TbxsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=2NchK2zG; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a59ec9bef4so225387b3a.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 03:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733092; x=1762337892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MnA5k8KsoV1ze5vVhBRV2+hvyms9kuv5Kp74LGBGZE0=;
        b=2NchK2zGlv+EVw2pnSu9QGxyAddEydVMwf0/imllChQpH6WJ8kbriJ0PdusBLyJcu+
         kCsLs8YDFXk66kA2woWkk6cJPSWhvBcbycD1+Ph5BcBAWPq5KOMa8yzJ8nv/+RTf9LN0
         5gUb3H3ubb9nBRfJ9g7z19oaLQp+uVncPVQvRLC+/pNBgEkSnBzqdI9dw4Nk9LbiJsGW
         GObBqFm4KFo4vUsCyRirEfuNz54AO1Mpn6t5CAwH3mVases6NsjN0hmWX55uZDTbyH6q
         7v1uIYidN8IAHRqNrR8mHkPeSbA4M5BydPE+29xEE0hV0X4I9bGzeeCw4kjyBtIoWCbW
         LTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733092; x=1762337892;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnA5k8KsoV1ze5vVhBRV2+hvyms9kuv5Kp74LGBGZE0=;
        b=jvC8MliH9U+KHe0r8+FifwlnfyJFa2OzdxyoKXnK+1TBw2ARHEZ13P/GyChjwGWwNn
         eOSQ3eFi/0F/kp7aFXRd84jIfURuJHcRL9z6nOyjWEC3GwHyVj2nPH+sNyL+RUo7IaM0
         Hw5yLoSGui1gbImAMbyqMAii2sOiNWTVWlr2C6VXVvZNM0R9DPvl32dDmx9mi9oq6bg2
         zX7sVZkhGg52Hhohc4pdvSPhRoBNPCh4s25MbVLSuWNCYwk011Y8l6q4kjC4IbnqPraQ
         Vjx0yeBh2TDaLvHZEtQdtbgRcqvE+vWmb+o1+j3v+QVMBb1f2OJ45p37Tcr50SXoFhGl
         5oxA==
X-Forwarded-Encrypted: i=1; AJvYcCW9VDwLdDevxOaRUAEnWL950xe4+QhYeH9CQRqIojDOtr+OEVUTiRa9mRlY6FU4bF3stfWBcmH5SJtUJrug@vger.kernel.org
X-Gm-Message-State: AOJu0YyrzByxZtcVCLNq5XlMUB/ZphynMrC1Pm4dgJLy9g1R0c3vH7W4
	orN3kaSN42tFsIeMh2A/GICTBxfvE4a3WhYaNJyzdvHI8cW4N+JYmaEMZXw3jl0kOAs=
X-Gm-Gg: ASbGncsA3iC4Mlhx3jjSjgg3H1xf4I/mbmf8T1UI0WPuTXVpYysbMdQ+CFVtV1780mm
	3Fjs0UJNySvQ7pZoladsbeswBtjTRmks0k9V8sjNsRez6K6ncHtO7D1uOW95cFuxCv+a7M9hX8g
	0QhWwaCmtKRem+jjAJRlVY3kNqIbsZWD5lWW1v4Gnw8yqaM4s7fJIf9D9xeyDBaXpp4EfwvYOK0
	uSKMNAGO6vsV1WpEYO6TvybFf9q49K0VrywHDDCqFYfR6qwaADmZ1B1h32Oww3SjrgesBlI4trD
	zAkqqvLYNtnlQEvEnPBvv7bIs6rOUOGW+e+JD7i+UluLQGSrQC9PyAdA3W0V0ixk6MmEtZMeTkJ
	n/OhsHE+AQBYlgMWV5K3RRbZWIpHqsOf0+0kL/8lom2gdesiTNX2tummZ0Sb8mb5KlDti4FmDRV
	bPTTHPXH3ZhJu8aGHndEL88XCP
X-Google-Smtp-Source: AGHT+IG12NVk5cbJTGyTVKHLaQKC7YUnZ6JUn/xWRMCP6ZX7N2wYfe554nd/X6z1OGt87h+b+ioXUA==
X-Received: by 2002:a05:6a00:1785:b0:771:ead8:dcdb with SMTP id d2e1a72fcca58-7a4e2dfdfebmr2813190b3a.8.1761733092228;
        Wed, 29 Oct 2025 03:18:12 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a42aa5d9a6sm11080454b3a.62.2025.10.29.03.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:18:11 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: akpm@linux-foundation.org,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	xiubli@redhat.com,
	idryomov@gmail.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me
Cc: visitorckw@gmail.com,
	409411716@gms.tku.edu.tw,
	home7438072@gmail.com,
	linux-nvme@lists.infradead.org,
	linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate users
Date: Wed, 29 Oct 2025 18:17:25 +0800
Message-Id: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a generic Base64 encoder/decoder to the kernel
library, eliminating duplicated implementations and delivering significant
performance improvements.

The Base64 API has been extended to support multiple variants (Standard,
URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
a variant parameter and an option to control padding. As part of this
series, users are migrated to the new interface while preserving their
specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
and NVMe is updated to BASE64_STD.

On the encoder side, the implementation processes input in 3-byte blocks,
mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
streaming and reduces loop overhead, achieving about a 2.7x speedup compared
to previous implementations.

On the decoder side, replace strchr() lookups with per-variant reverse tables
and process input in 4-character groups. Each group is mapped to numeric values
and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
rejecting invalid '=' usage and enforcing tail rules. This improves throughput
by ~43-52x.

Thanks,
Guan-Chun Wu

Link: https://lore.kernel.org/lkml/20250926065235.13623-1-409411716@gms.tku.edu.tw/

---

v3 -> v4:
  - lib/base64: Implemented padding support in the first commit to address the
    previously mentioned issue.
  - lib/base64: Replace the manually written reverse lookup table initialization
    with the BASE64_REV_INIT() macro for cleaner and more maintainable code while
    keeping the same behavior.
  - lib/base64: Simplify branching and tail handling while preserving behavior,
    reducing overhead and improving performance.

---

Guan-Chun Wu (4):
  lib/base64: rework encode/decode for speed and stricter validation
  lib: add KUnit tests for base64 encoding/decoding
  fscrypt: replace local base64url helpers with lib/base64
  ceph: replace local base64 helpers with lib/base64

Kuan-Wei Chiu (2):
  lib/base64: Add support for multiple variants
  lib/base64: Optimize base64_decode() with reverse lookup tables

 drivers/nvme/common/auth.c |   4 +-
 fs/ceph/crypto.c           |  60 +-------
 fs/ceph/crypto.h           |   6 +-
 fs/ceph/dir.c              |   5 +-
 fs/ceph/inode.c            |   2 +-
 fs/crypto/fname.c          |  89 +----------
 include/linux/base64.h     |  10 +-
 lib/Kconfig.debug          |  19 ++-
 lib/base64.c               | 161 +++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 294 +++++++++++++++++++++++++++++++++++++
 11 files changed, 445 insertions(+), 206 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1


