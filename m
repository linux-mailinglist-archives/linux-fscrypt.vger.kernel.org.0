Return-Path: <linux-fscrypt+bounces-501-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABB19A4610
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 20:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEEBB285A2E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 18:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21683204943;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCWm9W6j"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F34204018;
	Fri, 18 Oct 2024 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277105; cv=none; b=TRnoUqxd5EkqjTWZt+goNO7RWMYuDd+s8yjloVy4Bemccakiwu3s37v0TXzLjX5Popul1FxDMlFxHZK+qpDy2gn6Tx3hoRXMIiq43CFGsn9dyTYQooMCDlR68meNeJ9RxYBD7jbtkzK7vDztAmuw8FIQuOeaYa1AJviyia1ztYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277105; c=relaxed/simple;
	bh=ezUq8Gu+1gxpe+LETiT3thtchxlc506pUFTtsAKJMHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6XOWs1o9eS+pvVMoAXu2tNFpqGzyQJHq1eEtRQKwbYRKVcu58OVqZOWtHwkhFuG3Q+WC4YIQdZ9mwCmcvZZfMGjA/860RHUV+8flDrZxUA3gm1Kg4Ny88me+j78BZYJu1qZTn9NxJCknSDTxoppTBBmvopjG5M/zHnMM2QUiXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCWm9W6j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14439C4CEC3;
	Fri, 18 Oct 2024 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277104;
	bh=ezUq8Gu+1gxpe+LETiT3thtchxlc506pUFTtsAKJMHY=;
	h=From:To:Cc:Subject:Date:From;
	b=pCWm9W6j1rRPWi/RGVpopSxu3ME0YjjlmGkuaCHtilbMI1n5K/lgFXujKcxZnVOgP
	 Z+vXZ0iwvbcZ5E4GN3qQ7nn2jZOliV130WPq95w6cfhKn1Nlv+iwaLQPy+lyPPM75O
	 NdvkdEXUJURhHQ7+IVOPEtTDnu/CXYF81uv5ndOwn/itHHNFFZksshsRGq5Gu53Jvz
	 GoTO+HvohehDrrO7b1/c1+gEpjy2Rgok0knackTkbYqgPkbe4Lhq3JVa3++EMzou/K
	 YMtOpONL0Pmkhfzx9qOgs9EA3kJq3cvfdOM/S54m43F4DShItmMIsCucWQTupUAwTT
	 fszVNEg8x4hGg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Adrian Vovk <adrianvovk@gmail.com>
Subject: [RFC PATCH 0/4] dm-default-key: target for filesystem metadata encryption
Date: Fri, 18 Oct 2024 11:43:35 -0700
Message-ID: <20241018184339.66601-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds "metadata encryption" support to ext4 and f2fs via a
new device-mapper target dm-default-key.  dm-default-key encrypts all
data on a block device that isn't already encrypted by the filesystem.

Except for the passthrough support, dm-default-key is basically the same
as the proposed dm-inlinecrypt which omits that feature
(https://lore.kernel.org/dm-devel/20241016232748.134211-1-ebiggers@kernel.org/).

I am sending this out for reference, as dm-default-key (which Android
has been using for a while) hasn't previously been sent to the lists in
full, and there has been interest in it.  However, my current impression
is that this feature will need to be redesigned as a filesystem native
feature in order to make it upstream.  If that is indeed the case, then
IMO it would make sense to merge dm-inlinecrypt in the mean time instead
(or add its functionality to dm-crypt) so that anyone who just wants
"dm-crypt + inline encryption hardware" gets a solution for that.

Eric Biggers (4):
  block: export blk-crypto symbols required by dm-default-key
  block: add the bi_skip_dm_default_key flag
  dm-default-key: add target for filesystem metadata encryption
  ext4,f2fs: support metadata encryption via dm-default-key

 block/bio.c                 |   3 +
 block/blk-crypto-fallback.c |   2 +
 block/blk-crypto.c          |   3 +
 drivers/md/Kconfig          |  20 ++
 drivers/md/Makefile         |   1 +
 drivers/md/dm-default-key.c | 431 ++++++++++++++++++++++++++++++++++++
 fs/crypto/inline_crypt.c    |  14 +-
 fs/f2fs/data.c              |   6 +-
 include/linux/blk-crypto.h  |  36 +++
 include/linux/blk_types.h   |   3 +
 include/linux/fscrypt.h     |  14 ++
 11 files changed, 531 insertions(+), 2 deletions(-)
 create mode 100644 drivers/md/dm-default-key.c


base-commit: c964ced7726294d40913f2127c3f185a92cb4a41
-- 
2.47.0


