Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC70073D22
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 22:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388826AbfGXUO7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 16:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404347AbfGXTy2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:28 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 407C920665
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2019 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998068;
        bh=HlotYFGesVCZ1A/BHFB764ipjxS1NAwsHV9VLYrSDbU=;
        h=From:To:Subject:Date:From;
        b=Q4C7lQXyXkizOFpseVmJD4VPppt1nmg2j9JPt2P3ZCEaKsuQs16NT0GIliFOyaKK/
         Nu01I6NVWVyy1/W6VUlfImeIU8CjMztRWA0HpskcpWDfsYCe9lMe1V7SeGzlIMspw6
         z6jW+OsjRPiw+iLX+qO1VF5e6rsX/Z3VEy86wBlc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 0/4] fscrypt: logging improvements, and use ENOPKG
Date:   Wed, 24 Jul 2019 12:54:18 -0700
Message-Id: <20190724195422.42495-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Patches 1-3 make some small improvements to warning and error messages
in fs/crypto/, including logging all types of unsupported encryption
contexts rather than just ones where the encryption modes are invalid.

Patch 4 changes the error code for "missing crypto API support" from
ENOENT to ENOPKG, to avoid an ambiguity.  This is a logically separate
change, but it's in this series to avoid conflicts.

Eric Biggers (4):
  fscrypt: make fscrypt_msg() take inode instead of super_block
  fscrypt: improve warning messages for unsupported encryption contexts
  fscrypt: improve warnings for missing crypto API support
  fscrypt: use ENOPKG when crypto API support missing

 fs/crypto/crypto.c          | 13 ++++----
 fs/crypto/fname.c           |  8 ++---
 fs/crypto/fscrypt_private.h | 10 +++---
 fs/crypto/hooks.c           |  6 ++--
 fs/crypto/keyinfo.c         | 61 +++++++++++++++++++++++++------------
 5 files changed, 57 insertions(+), 41 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog

