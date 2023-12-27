Return-Path: <linux-fscrypt+bounces-102-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9DE81F0CB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Dec 2023 18:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 096301C222D0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Dec 2023 17:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 115D346532;
	Wed, 27 Dec 2023 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMposGQl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A0346524;
	Wed, 27 Dec 2023 17:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142FBC433C7;
	Wed, 27 Dec 2023 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703697441;
	bh=sVWMX+bfKbpj+wN2Tqsk9pRNhX9g1Y9VDLF6ogCKIBc=;
	h=From:To:Cc:Subject:Date:From;
	b=JMposGQlfLgWKnwk0tei8OPpwATRoex/30SSzdm5BSZfMukmRFesc8v/HL53j5lJ3
	 5ygHH92sLb6OfeJbOPDaG013CS2haUxW4zBWw4XX4xMNKyxu5FEWVLfswqtvUVvcK/
	 rHj2PCY+kawWDNfJ9O2YHPgL+wLljBglBU+FDidNjy3WgqzlckuJ+vikyPItsbQH3m
	 Bo3rimbhgnN3k7m+NNiS+dNXAPLxvPufL79li3Je7TNXy079S6n08njYHjeBBYTYzN
	 VxAWJnDIHgNXQFMMLf+EndFo44HQCNRlsnptjCRoSn2wwHlQZbsJ/GWr7Cij58+b9g
	 JdErdSfPipYWg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 0/2] Move fscrypt keyring destruction to after ->put_super
Date: Wed, 27 Dec 2023 11:14:27 -0600
Message-ID: <20231227171429.9223-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series moves the fscrypt keyring destruction to after ->put_super,
as this will be needed by the btrfs fscrypt support.  To make this
possible, it also changes f2fs to release its block devices after
generic_shutdown_super() rather than before.

This supersedes "[PATCH] fscrypt: move the call to
fscrypt_destroy_keyring() into ->put_super()"
(https://lore.kernel.org/linux-fscrypt/20231206001325.13676-1-ebiggers@kernel.org/T/#u)

Changed in v2:
- Added a comment to f2fs patch.
- Dropped btrfs patch from series; it will go in separately.
- Added some Reviewed-bys.

Eric Biggers (1):
  f2fs: move release of block devices to after kill_block_super()

Josef Bacik (1):
  fs: move fscrypt keyring destruction to after ->put_super

 fs/f2fs/super.c | 13 ++++++++-----
 fs/super.c      | 12 ++++++------
 2 files changed, 14 insertions(+), 11 deletions(-)


base-commit: fbafc3e621c3f4ded43720fdb1d6ce1728ec664e
-- 
2.43.0


