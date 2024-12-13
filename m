Return-Path: <linux-fscrypt+bounces-568-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA649F0437
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 06:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF206283288
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B7B16BE20;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hldht2cN"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E361684AC;
	Fri, 13 Dec 2024 05:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067736; cv=none; b=tSrtG9wZQlgB8fT+m4zsNlB4+/JHHNNH3+4HlFb62eaOYdTtwzUgRu46LjO4upvrYumvL6oHz2rYqa2TUv/MKTuV/LlemQr4zYRqtJNQ45K3VpNYDSyC7gkEMCSVLzzOqi6YBSLlSwfjUtSPPsbkRg7iuHS2Fekf6RVY3nmd3f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067736; c=relaxed/simple;
	bh=Mu3y6Gr4k8wdMlXZaBzCdltH/Bbcvjk6XBXtYOlCxRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gBQPzInO0KEpcrvPyi48Joa2tdoXsJRtdOFWXGk4M+e4A37tSNnsJ2krklMPFO8Zvb/OT/lR8bkYlKYeSNE4/smqMtr7cfc642r+zueC8VDXF70OTFVw2XuzpJSIN4htTlCL/vJw95LlBhKSX1Dp7Av1cUoeGyI4sMyw8Goozi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hldht2cN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C243C4CED1;
	Fri, 13 Dec 2024 05:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734067735;
	bh=Mu3y6Gr4k8wdMlXZaBzCdltH/Bbcvjk6XBXtYOlCxRU=;
	h=From:To:Cc:Subject:Date:From;
	b=Hldht2cNsTS5dzQkcaFFgpCiSKKHHm2dUp2vf1reoP4Q8JZSvGe3ok6ftRjSL7yPE
	 kU8TbPy4LvuKM5+rAz7YyE9PWzDIkCmm1bsT7RpeUhrhS2SU4+EUftcfhup6XFJCNR
	 Ja74+U95e9AKqs2yzz3kLGQdyZphnyGMW75LovtElMFtxcYHoMy9vNsr1+CBtXS+cU
	 SYRGhZ2Gad27wJFlCWh4Tc0ckVjcrdeAgktkhTUkPYZ3Gbr93xp3lc8YCFLQuuTcdS
	 AfOOia0H3ubqu1QmcnTBV7nQ1OvLnRtcErYBV1TC0/taVHZfHgfk9qsoMNK6JNapjN
	 SDMEmBMaXMwwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 0/3] xfstests: test the fscrypt hardware-wrapped key support
Date: Thu, 12 Dec 2024 21:28:36 -0800
Message-ID: <20241213052840.314921-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a refreshed version of my hardware-wrapped inline encryption key
tests from several years ago
(https://lore.kernel.org/fstests/20220228074722.77008-1-ebiggers@kernel.org/).
It applies to the latest master branch of xfstests (8467552f09e1).
It is not ready for merging yet; I am sending this out so that people
have access to the latest patches for testing.

This corresponds to the kernel patchset
"[PATCH v10 00/15] Support for hardware-wrapped inline encryption keys"
(https://lore.kernel.org/linux-fscrypt/20241213041958.202565-1-ebiggers@kernel.org/).
In theory the new tests should run and pass on the SM8650 HDK with that
kernel patchset applied.  On all other systems they should be skipped.

Eric Biggers (3):
  fscrypt-crypt-util: add hardware KDF support
  common/encrypt: support hardware-wrapped key testing
  generic: verify ciphertext with hardware-wrapped keys

 common/config            |   1 +
 common/encrypt           |  80 ++++++++++++-
 src/fscrypt-crypt-util.c | 251 +++++++++++++++++++++++++++++++++++++--
 tests/generic/900        |  24 ++++
 tests/generic/900.out    |   6 +
 tests/generic/901        |  24 ++++
 tests/generic/901.out    |   6 +
 7 files changed, 377 insertions(+), 15 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out


base-commit: 8467552f09e1672a02712653b532a84bd46ea10e
-- 
2.47.1


