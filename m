Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EE819B707
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Apr 2020 22:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbgDAUe5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 16:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732821AbgDAUe4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 16:34:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCFF2082F;
        Wed,  1 Apr 2020 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585773295;
        bh=Lkegc6/p8gRLQQ0hP6UVszjf/sI5WbF2HCMlwMjtYDA=;
        h=From:To:Cc:Subject:Date:From;
        b=1SDYC/nWbgmXoEIi916NjDiByqsEStNGZ/nU5PKwRbPJEhWdjVlKHM/2vPlFJeYVb
         6wNaSAbcoKhw4E5du6kun0K/ROUKttnl1ppjKKmR+04s3XTu4U+EFT/CrZV6ayDSSj
         ZmSeKsM431UmGqU7yw0YCv+qQNA5yOahyWtP3pWU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Date:   Wed,  1 Apr 2020 13:32:35 -0700
Message-Id: <20200401203239.163679-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
(which can exist if the stable_inodes feature is set) could be broken:

- Changing the filesystem's UUID
- Clearing the stable_inodes feature

Also document the stable_inodes feature in the appropriate places.

Eric Biggers (4):
  tune2fs: prevent changing UUID of fs with stable_inodes feature
  tune2fs: prevent stable_inodes feature from being cleared
  ext4.5: document the stable_inodes feature
  tune2fs.8: document the stable_inodes feature

 misc/ext4.5.in    | 16 ++++++++++++++++
 misc/tune2fs.8.in |  7 +++++++
 misc/tune2fs.c    | 10 ++++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

-- 
2.26.0.rc2.310.g2932bb562d-goog

