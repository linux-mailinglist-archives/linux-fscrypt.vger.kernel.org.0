Return-Path: <linux-fscrypt+bounces-637-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90017A7C69E
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 01:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FE7F189E2DD
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 23:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F791C84A3;
	Fri,  4 Apr 2025 23:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HC707Fb4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7948D18B0F;
	Fri,  4 Apr 2025 23:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743808590; cv=none; b=OJlIudHW3nZ/b3U9rTCIDhxP4/OIt38Jg24lcI63+GZN4ALpisZ4r64QjMyWsIiT1bRqCw94+seuz7Rds0EdL3nXbmRXryuf/CZyf2eF0mM6PYoonO4JzA9ysRDcuslsAX3kQcIW5UsfEfBCvZLgyG71DCKFsL0vtTLYFduVbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743808590; c=relaxed/simple;
	bh=a10Q9Ma7MD/VR8BzsfOmPfGlA+UjLN4nSEz5RkKXJkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IuRn3EF002MyDwBYJBToItHSDxAw8iRv1S1LftjKQyJuGgigv7/PYxpXvyiTtqDNnLRvrqNijB6UtvFRq5AmlxYgshkus7KZIr5LbP+EhNBwCWVFnjlXxfhVJTSZjsZcIYPWaZ32bw+htnWk83lpR4j6Y57N0z3mc99uWb+ivfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HC707Fb4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83194C4CEDD;
	Fri,  4 Apr 2025 23:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743808589;
	bh=a10Q9Ma7MD/VR8BzsfOmPfGlA+UjLN4nSEz5RkKXJkc=;
	h=From:To:Cc:Subject:Date:From;
	b=HC707Fb4rfyT06TzPoefdxgwkDVYummHaklVJ8lSzK4wekZbDuwuUEbyHzssKkDlU
	 QzhOuZmfJcNc8V++fvMY3qoLlSvmJaZ2a2rihPtp1vZ3jBqf1SubTnOnNvLvmJbU0z
	 eTY197AW/4oA+fX4COlHHCEnINmnlDyJs80Soq+wmDTB4PWcQ0Hw9n5bSW16zMgICn
	 gNauJrpI8YgL9zJJ+x3v4OBn47x2GPnXiFDh0WAGmplhr/9mOyEBLixgJUobxZtlG8
	 Br76BBWLii6UD6AKr5U97l3E3wFbagA5BAomYYefBxWHNSGTB2WsfqhbrUspHTZJ4n
	 wr53r6nn6h4nA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v13 0/3] Support for wrapped inline encryption keys on Qualcomm SoCs
Date: Fri,  4 Apr 2025 16:15:29 -0700
Message-ID: <20250404231533.174419-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for hardware-wrapped inline encryption keys to the Qualcomm
ICE (Inline Crypto Engine) and UFS (Universal Flash Storage) drivers.

I'd like these patches to be taken through the scsi tree for 6.16.
But the Qualcomm / msm tree would be okay too if that is preferred.

The block layer framework for this feature was merged in 6.15; refer to
the "Hardware-wrapped keys" section of
Documentation/block/inline-encryption.rst.  This patchset wires it up
for the newer Qualcomm SoCs, such as SM8650, which have a HWKM (Hardware
Key Manager) and support the SCM calls needed to easily use it.

Tested on the SM8650 HDK with xfstests, specifically generic/368 and
generic/369, in combination with the required fscrypt patch
https://lore.kernel.org/r/20250404225859.172344-1-ebiggers@kernel.org
which I plan to apply separately.

Changed in v13:
   - Rebased onto latest upstream
   - Resent just the remaining driver patches

For changes in v12 and earlier, see
https://lore.kernel.org/r/20250210202336.349924-1-ebiggers@kernel.org

Eric Biggers (2):
  soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
  ufs: qcom: add support for wrapped keys

Gaurav Kashyap (1):
  soc: qcom: ice: add HWKM support to the ICE driver

 drivers/mmc/host/sdhci-msm.c |  16 +-
 drivers/soc/qcom/ice.c       | 350 ++++++++++++++++++++++++++++++++---
 drivers/ufs/host/ufs-qcom.c  |  57 ++++--
 include/soc/qcom/ice.h       |  34 ++--
 4 files changed, 396 insertions(+), 61 deletions(-)


base-commit: a52a3c18cdf369a713aca7593332bbb998c71d96
-- 
2.49.0


