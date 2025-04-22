Return-Path: <linux-fscrypt+bounces-648-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CE1A979A8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Apr 2025 23:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EB717AF79C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Apr 2025 21:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3873222F76C;
	Tue, 22 Apr 2025 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVCHo8wV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E4722F749;
	Tue, 22 Apr 2025 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745358167; cv=none; b=FHLKG4B1STs5UL3d6vzXOG0xCVcX7acDcMdiw4MtUmLe8s3pFL+kCefIacmIFbWJKefb1f8OWgGE1h+kP45rTI5S4SuCj9I3SiIdTeEjX4/kg6snd2qRN3ImsQzDmqWYgw0UswiJwqkTBKBQJ7m+ljqMr++ssaAaBQRcYw6f9rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745358167; c=relaxed/simple;
	bh=XJOAal0eej/hpjafnYsPOwPv+ZuBSzbT1WvNHczepS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zuecn8cBrYOmeZaWnmtgH2dIogDrHzV/vMGH1sDz+n85QtGb6T8lR6y+Ji5ICFhapObRion/5zufiNx4SLqFFFcOL3MKqSeXYFUEbegxZNltDO8XX7OAfmnOVcls1uHXkUyz25dBKcYz4hegJFPhTzkW+StPJopoxFAJkUN239A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVCHo8wV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A7C4CEE9;
	Tue, 22 Apr 2025 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745358166;
	bh=XJOAal0eej/hpjafnYsPOwPv+ZuBSzbT1WvNHczepS8=;
	h=From:To:Cc:Subject:Date:From;
	b=EVCHo8wVpNEynXke1S0+6DfigRaXdwEedHx1W9ioTEHeFQ+r2EnsMc9yxg6pxUjmR
	 Ud7Gm2yYBPR5sWaMrLWjFfkYmyWscBmykdQ899CR9VIKfxstLBSi/TpI0HZfKzfhbN
	 t4YvrEvuQSfe3KrMxrOh2rDJuwC1WPxtS5mk1VaUuOHDLOmI0UJYhTkbLcoaMuFnqT
	 Bo8348w5hb78gYl5GX1lYB3pmSJPCFj0CS43OXyhDesoTrifYJnxyt9MVBAC8Bgt1F
	 bBE05SbHx0pvLeUV0BM44hC9jIPXribB0jdEkiuq+R/RlgKFGWNBSyuKUO6Ui7fhAq
	 TAlzE5BKJB2ug==
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
Subject: [PATCH 0/2] dm: pass through operations on wrapped inline crypto keys
Date: Tue, 22 Apr 2025 14:42:09 -0700
Message-ID: <20250422214211.242382-1-ebiggers@kernel.org>
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

Eric Biggers (2):
  blk-crypto: export wrapped key functions
  dm: pass through operations on wrapped inline crypto keys

 block/blk-crypto-profile.c |   4 +
 drivers/md/dm-table.c      | 175 +++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)

base-commit: a33b5a08cbbdd7aadff95f40cbb45ab86841679e
-- 
2.49.0


