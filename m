Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4D89473
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Aug 2019 23:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfHKVhN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfHKVhN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4332084D;
        Sun, 11 Aug 2019 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559432;
        bh=M5OO0DAuM0LyMiWiAitlxQ1KgWp1hgxg7lV0HmBjAzE=;
        h=From:To:Cc:Subject:Date:From;
        b=1Uu7QZwbKglvie2v3Mu15XkOb3jsT8kJ2qcgpC7QaCRTFHn0D6ojqNFFMwovEZYXA
         1oIU5mXMWyju0Xfp4QxhNpuvHKtzyNnAODDXuttxUaiEF2iqP4U867di7+PWESxY+q
         hnmDWTYRGPfxheR6V0VpqsRVMIz/EkS8hqRxlnXM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 0/6] fs-verity fixups
Date:   Sun, 11 Aug 2019 14:35:51 -0700
Message-Id: <20190811213557.1970-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

A few fixes and cleanups for fs-verity.

If there are no objections, I'll fold these into the original patches.

Eric Biggers (6):
  fs-verity: fix crash on read error in build_merkle_tree_level()
  ext4: skip truncate when verity in progress in ->write_begin()
  f2fs: skip truncate when verity in progress in ->write_begin()
  ext4: remove ext4_bio_encrypted()
  ext4: fix comment in ext4_end_enable_verity()
  f2fs: use EFSCORRUPTED in f2fs_get_verity_descriptor()

 fs/ext4/inode.c    |  7 +++++--
 fs/ext4/readpage.c |  9 ---------
 fs/ext4/verity.c   |  2 +-
 fs/f2fs/data.c     |  2 +-
 fs/f2fs/verity.c   |  2 +-
 fs/verity/enable.c | 24 ++++++++++++++++--------
 6 files changed, 24 insertions(+), 22 deletions(-)

-- 
2.22.0

