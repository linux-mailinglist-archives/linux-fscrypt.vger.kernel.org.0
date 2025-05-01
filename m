Return-Path: <linux-fscrypt+bounces-651-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1302AAA654E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 23:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E1BB167D54
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 21:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D7B2609EE;
	Thu,  1 May 2025 21:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIojzI+V"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D91253350;
	Thu,  1 May 2025 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134664; cv=none; b=Mv9Buqw2ZiDvMRPYvrmrruv7dsR+NwObBFGuZWM7VVCJcl72APD78PTUm5qNiSFMqwVAQRCjTJRWS6BnDNyVa7gPju0nB+u0mxrOA06kI9o0lePW7rFoFC1t0CuwpYcE647IqAU6QiEADpY8CseM1MTEJPXa9u9nx8/tag6R3Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134664; c=relaxed/simple;
	bh=M30ESeL4ZL0XiQvXMY06BT2bVpVu4mG2lKKyk1Vs4TM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tmf6XCrjpuWq5YXALaZcP3CuIaloiL7ziBQYdE8h7dFUqR947bw5PvmCOJECOaeCuM1k6FFczYzP36pOxDmNeSFAaPC9X+lbKxY4Q29CP7Nu0giHIAxwKD/UdM6YeqR/RBASEHtHbq+car3+Fx0QS2zHv4Decxa3+oSk7AKn7pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIojzI+V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D1DC4CEE3;
	Thu,  1 May 2025 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746134663;
	bh=M30ESeL4ZL0XiQvXMY06BT2bVpVu4mG2lKKyk1Vs4TM=;
	h=From:To:Cc:Subject:Date:From;
	b=GIojzI+V+24sfKWcupw3o7CWLb0uY5HhNguptncX6qekB7HG+O0jwvlNPQfpYrInk
	 VAHQCP3O6yOoLSwVNFSZlJMyC0FHJ9hQ4jP/jdFVpGzgPUgPssISq89O2lTXpwbBDe
	 5Ab8BcL3i2Nayu9+rCrAPGohpODbmldOPcnqCN+EORjkRY2Ic9yrCgOTuX4GTDoqpk
	 y2BYU367/hX5R7GGi+wzioI5mup41UeQMqYFjtrwqyFHBkXBLLSOt5GmfZMDqAK7l2
	 iSIKbSyqNTdn3hJKOjzLNB1qFPcJ7aPVqTTCySadn7T8mJXZIprWtDhaQsNlPU/5En
	 b1UKK5z5rVY9g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 0/2] dm: pass through operations on wrapped inline crypto keys
Date: Thu,  1 May 2025 14:23:18 -0700
Message-ID: <20250501212320.8281-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series makes the device-mapper layer pass through the blk-crypto
wrapped key operations when underlying devices support them.

This is targeting linux-dm/dm-6.16.

Changed in v2:
  - Call dm_put_live_table() even when dm_get_live_table() returns NULL.

Eric Biggers (2):
  blk-crypto: export wrapped key functions
  dm: pass through operations on wrapped inline crypto keys

 block/blk-crypto-profile.c |   4 +
 drivers/md/dm-table.c      | 177 +++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)


base-commit: d5d16fabe431d1f7b822cf03f54e7186b284b7bd
-- 
2.49.0


