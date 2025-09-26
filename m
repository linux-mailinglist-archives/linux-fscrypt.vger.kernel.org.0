Return-Path: <linux-fscrypt+bounces-842-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E306CBA293B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 08:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6F9A188FCC8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 06:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C270827FB1E;
	Fri, 26 Sep 2025 06:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="Xih1cGCo"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112D825DAEA
	for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 06:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869571; cv=none; b=eAc8ubizy8UMGWVcGVDsC+xxjnIWIYFQpu+EcMXLbKQEwOtEc4ExIedh4UO/m4sVDV2w30QDPe+DVbcadDTl2iz6flpjAqglho9CiXVYuQEb/tjQXSzPwcqTE8mrw4YUS1Z7Aa2NP1McLu6BNAQW9UFHXkZ162qNHWouHkFZtBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869571; c=relaxed/simple;
	bh=MF2CG7Pen5t7tCXTDq6YKl65DZH9W8CJ9N9hr6Pgke4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y83yq8KU+oVX9DMx5AGLg7gYaAndGLdGtzAobjBGt9EF8REZUCUQvcIHIJABZvzrpk0kYGj8yU6JWdr2kmXk+ewh8LwGGuO8ax0sDgVpJ8y3UT2ZXgHQPD4e68rOCsH0nTmffjgR7MAR4r5bhGV7uQhsszvTCET6Vqg0G7wHzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=Xih1cGCo; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3322e63602eso2312231a91.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Sep 2025 23:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869567; x=1759474367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t49lkyvPjjmG8vWQnPs19unibZLUCNGA1EtqRug4pDY=;
        b=Xih1cGCoBw9b/rU4hNOIEAkzK06CFB257bjmH948HUuxWr7vCdnyYEQael+1UYlNT4
         YbrBd768pkR4rjQSRnLUkITDYsMc2Ctwyc+DaymwZdtuicF5FHNHvcrslCAvNRn4D/75
         bf82ej9bKVGNc4RRbEUOMxbTCGPO8ODCDXLaWRbGw58R+fPetaDVeX/hHJYsX0Gd6ZdO
         8OZzYuUz8qL5fIgEMUaXlSRlvo/TvrzfjgVFkfXYFz2CDO1NeFaJh3cKjiw+b6Xes94i
         JvF9bmvdZ+1GcHL5U9tb04YvS0LB5O3xbIFTehTAHlhb2c1cP2vH/yFGSY7k3Ys0d8+B
         FtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869567; x=1759474367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t49lkyvPjjmG8vWQnPs19unibZLUCNGA1EtqRug4pDY=;
        b=A7shggxxc6sThp9LUzaEkaScqaFW8s94sD2dTTyv79ODHmEgE5z+T7shKlKAFZIANZ
         wV3sMGuHNv81LemMW+TJmd3ooqPm/ylkDpmq+goRW8KgThr1vPGtDS/IU1CbTIkCKu7S
         MCJG6BtM/IVR3wLn0J1HvLp1n7pwEamo9gIF9G/d/fTf36sjxCiQw9rf4bOu7kg/QMAB
         R4179vlhvCyYl17zDphxIfNHGR/t4hb1p87OuM6iFSUS4qWIjH1EuIXnK6DnGzSSBHao
         7ga8qlQB5h55l92qP/9B1+aZ/rao4uQS5jd8f4sb6VcELfhpbVYs7KpsC8whdKX99O2G
         KAig==
X-Forwarded-Encrypted: i=1; AJvYcCXkJFBST32l0pv07iEs3qbyjqbM6O76lu5Z72tbL1AApTnA6unANT+FH5a062/8tX5wu38T+wb8s0VKXmbR@vger.kernel.org
X-Gm-Message-State: AOJu0YyuJLfwF38EcRWa8Bt+x7CI2XTEVTgDAttzotSFy6iemLIjOQlH
	yz07B59uBJzx2IkxjWsTxXJqYpEaAEG1xDMuAtH44Q+8izSosPa6ttrjK6R06dB83qs=
X-Gm-Gg: ASbGncu1hiqjbIKT3oNfST7Vp9GKr6uGTcb4Xl7wAZAuWLUmu2bpIq00vNAnVWrJRcd
	+AdWGL+i6wxQCFPjnVI0ORCmHhff8TbvvA9uGd9geVnNEL+8zqAP2p31x4fh3MhqYSRLpsjxtEE
	FCZKvxnivpmlsrLdG+jYeZ/qkT6YtcqHoLUSl8fM/1qjrjO0VosRCP2i1YFZgHqGXbU5kal6sxE
	wX3aCOaKnlRljDrBCB62wdL+K8D6LMDzIjzu/oJfxfNUfu7au9fGrSRs/DyIUb/iYEs0z2fH5C8
	NDsHf8K6WIKjbBoTzXhZYmSO1SwZXzL1dNabv63mGcOFUcqWavrlHA1dvn/ulfrUpHznZTuhMQO
	xN6t1jcMDqcAtkjnI81KEH1ToHjbqbyEQmXlamOgc/1CjKTMbE5slDCzLOw==
X-Google-Smtp-Source: AGHT+IH/5rSRyxyzzwAVf8GtjSII3G3mtDPelN6ys1aTgI14FWVKkGLrFodstg9rym1zwY+fBiFhZw==
X-Received: by 2002:a17:90b:4c06:b0:335:28e3:81cd with SMTP id 98e67ed59e1d1-33528e38f06mr2280913a91.18.1758869567293;
        Thu, 25 Sep 2025 23:52:47 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c2b76esm3556178b3a.102.2025.09.25.23.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:52:45 -0700 (PDT)
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
Subject: [PATCH v3 0/6] lib/base64: add generic encoder/decoder, migrate users
Date: Fri, 26 Sep 2025 14:52:35 +0800
Message-Id: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
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
by ~23-28x.

Thanks,
Guan-Chun Wu

---

v2 -> v3:
  - lib/base64: introduce enum base64_variant { BASE64_STD, BASE64_URLSAFE,
    BASE64_IMAP } and change the API to take this enum instead of a
    caller-supplied 64-character table.
  - lib/base64: add per-variant reverse lookup tables and update the decoder
    to use table lookups instead of strchr().
  - tests: add URLSAFE/IMAP checks (no '=' allowed) and keep STD as the
    main corpus.
  - users: update call sites to explicit variants (fscrypt=BASE64_URLSAFE,
    ceph=BASE64_IMAP, nvme-auth=BASE64_STD) while preserving formats.

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
 lib/base64.c               | 241 +++++++++++++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 294 +++++++++++++++++++++++++++++++++++++
 11 files changed, 525 insertions(+), 206 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1


