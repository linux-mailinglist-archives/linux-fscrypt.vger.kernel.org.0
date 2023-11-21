Return-Path: <linux-fscrypt+bounces-7-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D467F394D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5506A1C21027
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 22:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBEC4204B;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhpw0ES8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512C116405;
	Tue, 21 Nov 2023 22:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD6C433C7;
	Tue, 21 Nov 2023 22:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700606375;
	bh=F7T9ozkx5kq3xFIaUUxDQId3Ryj4a172IH01F7bLlaA=;
	h=From:To:Cc:Subject:Date:From;
	b=lhpw0ES8jbh5enMJozW9b9tfugeonU6dStP/RBqgzl6iW4a2QYjdVbrLamfcFe6ZM
	 n1AfA68K0vk7gYwZ4DVK6cBs7YgncKMSPbJ+48E0DKjGJqloppllX1aI+hvM/Psard
	 eDLY8DTaFPpYB9LOnb7BLfW1Vg4TtTE6T0qOXFK5HxayRph8zgZdsSjJDbpm2Nxf6M
	 /3PxIQ67MLlFu+4GEn38Idncz6/l1K7ljSl0Sxk4XHP6cAmkWnYkb2EZLVl1cwsVl6
	 l9kRe3IvMRhHJs+1bmn/WtqDcXNBF/F6sqM8CAzZXNi164XKNgq4l/o5Z3w6emAgVB
	 00EsoXKMJbGUw==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 0/4] xfstests: test custom crypto data unit size
Date: Tue, 21 Nov 2023 14:39:05 -0800
Message-ID: <20231121223909.4617-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a test that verifies the on-disk format of encrypted
files that use a crypto data unit size that differs from the filesystem
block size.  This tests the functionality that was introduced in Linux
6.7 by kernel commit 5b1188847180 ("fscrypt: support crypto data unit
size less than filesystem block size").

This depends on the xfsprogs patch
"xfs_io/encrypt: support specifying crypto data unit size"
(https://lore.kernel.org/r/20231013062639.141468-1-ebiggers@kernel.org)
which adds the '-s' option to the set_encpolicy command of xfs_io.

As usual, the test skips itself when any prerequisite isn't met.

I've tested the new test on both ext4 and f2fs.

Changed in v2:
- Updated the cover letter, commit message, and a comment to reflect
  that the kernel commit that added this feature was merged in 6.7.
- Rebased onto latest for-next branch of xfstests.

Eric Biggers (4):
  fscrypt-crypt-util: rename block to data unit
  common/rc: fix _require_xfs_io_command with digits in argument
  common/encrypt: support custom data unit size
  generic: add test for custom crypto data unit size

 common/encrypt           | 42 +++++++++++++-----
 common/rc                |  2 +-
 src/fscrypt-crypt-util.c | 93 ++++++++++++++++++++--------------------
 tests/f2fs/002           |  6 +--
 tests/generic/900        | 29 +++++++++++++
 tests/generic/900.out    | 11 +++++
 6 files changed, 123 insertions(+), 60 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out


base-commit: b9e1a88f8198ac02f3b82fe3b127d4e14f4a97b7
-- 
2.42.1


