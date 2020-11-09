Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B2E2AC919
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Nov 2020 00:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKIXLy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Nov 2020 18:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKIXLy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Nov 2020 18:11:54 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865D0206ED;
        Mon,  9 Nov 2020 23:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604963513;
        bh=SQGVZLRUPKvsYZo0PlF8JXHcSnUYadSZmBvAvzL4DZY=;
        h=Date:From:To:Cc:Subject:From;
        b=PBKdobLpDpkxzWyk+sUsVd4ocrgm8wqltbRYhCEkVsQ+Wkngfassg48eIKcWp5BHd
         iULIFLwOywhwjYtkJ4wWse9/buXBizqWnQVt5RrmYxEzuQkuARQfYpPIAT6c8hZajx
         +6yN/CB8LMLhEFyIX3tEVByvY/tzySt9Vb5jc4wI=
Date:   Mon, 9 Nov 2020 15:11:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [GIT PULL] fscrypt fix for 5.10-rc4
Message-ID: <20201109231151.GB853@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The following changes since commit 3cea11cd5e3b00d91caf0b4730194039b45c5891:

  Linux 5.10-rc2 (2020-11-01 14:43:51 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt-for-linus

for you to fetch changes up to 92cfcd030e4b1de11a6b1edb0840e55c26332d31:

  fscrypt: remove reachable WARN in fscrypt_setup_iv_ino_lblk_32_key() (2020-11-06 09:48:55 -0800)

----------------------------------------------------------------

Fix a regression where a new WARN_ON() was reachable when using
FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 on ext4, causing xfstest generic/602
to sometimes fail on ext4.

----------------------------------------------------------------
Eric Biggers (1):
      fscrypt: remove reachable WARN in fscrypt_setup_iv_ino_lblk_32_key()

 fs/crypto/keysetup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

