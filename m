Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF71CE3AC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 May 2020 21:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgEKTQh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 May 2020 15:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgEKTQg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 May 2020 15:16:36 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50247206E6;
        Mon, 11 May 2020 19:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589224596;
        bh=tBesqsTZnw0kx/Akr2tFasAZ+I+4QbG0o21sc6BMcfI=;
        h=From:To:Cc:Subject:Date:From;
        b=XamP3kJWjE2sYmlIKlfYZ56Lg+nYobrBaj0d1gSAiulPa2bvLPDDqmh/sSDGbGpLU
         vFTnSRrn/7/w8sF0ijX1uMCF4Lg6sMQ1q+TGXP+yPKXEbeNQ5n/qcqSRPBRxD+5xRi
         VGrijh9MkSub8sMxCvRQnCXatalBjz/FQio+FoP8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 0/3] fscrypt: misc cleanups
Date:   Mon, 11 May 2020 12:13:55 -0700
Message-Id: <20200511191358.53096-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In fs/crypto/ and fscrypt.h, fix all kerneldoc warnings, and fix some
coding style inconsistencies in function declarations.

Eric Biggers (3):
  fscrypt: fix all kerneldoc warnings
  fscrypt: name all function parameters
  fscrypt: remove unnecessary extern keywords

 fs/crypto/crypto.c          |   9 +-
 fs/crypto/fname.c           |  52 +++++++++---
 fs/crypto/fscrypt_private.h |  88 +++++++++----------
 fs/crypto/hooks.c           |   4 +-
 fs/crypto/keysetup.c        |   9 +-
 fs/crypto/policy.c          |  19 ++++-
 include/linux/fscrypt.h     | 165 ++++++++++++++++++------------------
 7 files changed, 193 insertions(+), 153 deletions(-)

-- 
2.26.2

