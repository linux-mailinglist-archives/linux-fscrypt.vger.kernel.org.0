Return-Path: <linux-fscrypt+bounces-957-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6F6C5B710
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC94B4E8AD2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 05:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411BB2D839E;
	Fri, 14 Nov 2025 05:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="SUp2liwD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8982741C9
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 05:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099921; cv=none; b=la8EkjAnnDBh2T2WUBIJ8Hh3x8bZ/ZNbMfDQQBFcgbHvpw0rAwKDkvHWjKgJ7rQ4Ll783/inJqkv4jSdIItEjQRMRVUsQ7CNBnPYixA4bEe4wjrP3SHefHrN3EXeZMsJf5CNvr6bNoDgbwtTdh5bRhgoOJ65vwj9p0ELrPIGwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099921; c=relaxed/simple;
	bh=RHXnTFY4Vjt79fDUxT3cRYXGuRmkpqXY8Q1+NN8qIIk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GHaB0HLFw3WeSZvH90J6WvH3/d5RzZdRlg8z+Rs7Fe5fdoW01xTRhc9QEjwk/Z1a2OjWNpjwQbjTsKlxnkISNkHj7lrKAv1+XE05UOPWG8mvRJm9ZZ7CemH8OL7Gnr4hqg1P7P1Vhp02VQsbyficJERnWs2ZuaRIy9BOCX2GJ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=SUp2liwD; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29516a36affso16900985ad.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 21:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763099917; x=1763704717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fupJk9ycgxTR9K+qzkaB5UIJKdModxQ3EoXqNJbHRwk=;
        b=SUp2liwDkCBhLBgCyXBL+v/ZZW9IwteFtvuO8Yk7uFlPp9DqODR9gfc9hvyYRkNqIc
         PumGeNJCNskSl5xWXchGXmRr8NRDU01Gnq4RT2yenQMRZFj5dPub3kra36L0P7H90a1B
         UpowwhnQHFX2xPC5JZAy1ciO6LUrjxpHbRh0a/ZGnR+0HzzKLDp+K1KAdTI6vjCENjEQ
         1jU53sPR+usds0kEhLM2QGn4h19/FgzDjPeUQb/bLaDL96mT6v4HwnwarK71P4i1zs01
         PNOdRSw9/Ys6xsOOg8qNEx+5vGTGobzGMfstI1KyBNLbdtB0/FylM8kAoAOm/+K6QRfi
         6Urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763099917; x=1763704717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fupJk9ycgxTR9K+qzkaB5UIJKdModxQ3EoXqNJbHRwk=;
        b=katdsVdpxdFVVujkQMBxl6kbD2VrBhvBp15Dfn0kUzlVBwBnlf+dy8ptCXP3O9IR3U
         F/UGM4NRBNNlfSGjgQUAtGa32uoggFLchGQ+ilFAnQiwKWHarW3+gjQwFmgKF6Zt4HAz
         cz2RtRYz4qEbWiKtgVM06q/QDifvz6t95xTR3EejaezC/YmanCbkANekMW9tnzAvssP0
         wDWpnGK+F/R/em3BQ+xGGTaflKh676YB25Z/aRc3/Q2g2Eh9kUi09cnUhrugkKTNVq7f
         OJWw4iyBpmZKPj4nV3NT19OKrOEOCxhe7XeFWcthDVBmKfB5J6/RHuIdNU8k/piIQJM+
         PYLg==
X-Forwarded-Encrypted: i=1; AJvYcCV6X9zDHPlEV/jrwSHLjRLSXqwbEfo0X2zgNpDdTw1AuKZ5+hL1d2hvkbANlYMuQdllhTlj9JbZaTBuyRB6@vger.kernel.org
X-Gm-Message-State: AOJu0YyDH9UcgcB8P4fIi+vWsMfZYDhN4haacsO5GaXZRPVQnukWa6jD
	7EGEPAx7vhsO39OEX7TVbSW8Ojf/QN2kaaZpatWRwIoO2CxApscJaKuL5toS9DhBDxU=
X-Gm-Gg: ASbGncuZVr1P8N+pVJwvIFcByp9kHCXPbzMppf1fzY+BA2MMmKjvZuSOO+OPStngMY7
	jm4/gIevmgWcTFcXsU20rHoHKPr5GdJorEdH8lVDtgTubumypXD2UtF3egWGI+tdR1i5R/G/4ev
	sS1qOR6X5OEMdfp0OK0lE/Xgt9TlUAnEoXUhczhQZnm3ZQKwWn7JAZBedvecAOlFCiLgvD59MyD
	L9GxiB9bGBkVfmbaJXN0q87H56J3NuMW+OrBDaY/O7T+MpKCfjVtyu3O23iNWXXNYSS6MfgP11q
	wJOyIXY84/WZHr3CmRipf1NvDh+/ZSGeM0uZDd9t1llZG7iBO1QpXPgKH8As4qegzhvUM/8JdK5
	a7QkPpRdeMGAn3IxCIBb/CO+BuOgPuaSveZB84ZOadbUBjwbVY2vZ39GQW9wuyZMLGhAAXJD9gj
	BFR1uNnW4hRWBMLtCcBGOR2HUT
X-Google-Smtp-Source: AGHT+IFojfSCG/W0M3Jt5J4Jz8XjM+U4I16pRFtTj2FRmRxZFPiZbCx8UawP3/kCmEgwqKCvZRSjlA==
X-Received: by 2002:a17:903:2f0e:b0:24c:965a:f94d with SMTP id d9443c01a7336-2986a741b6cmr18474075ad.46.1763099917503;
        Thu, 13 Nov 2025 21:58:37 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2beb34sm43727825ad.76.2025.11.13.21.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 21:58:36 -0800 (PST)
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
	andriy.shevchenko@intel.com,
	david.laight.linux@gmail.com,
	linux-nvme@lists.infradead.org,
	linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/6]  lib/base64: add generic encoder/decoder, migrate users
Date: Fri, 14 Nov 2025 13:58:29 +0800
Message-Id: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
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

Link: https://lore.kernel.org/lkml/20251029101725.541758-1-409411716@gms.tku.edu.tw/

---

v4 -> v5:
  - lib/base64: Fixed initializer-overrides compiler error by replacing designated
    initializer approach with macro-based constant expressions.

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
 lib/base64.c               | 188 +++++++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 294 +++++++++++++++++++++++++++++++++++++
 11 files changed, 472 insertions(+), 206 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1


