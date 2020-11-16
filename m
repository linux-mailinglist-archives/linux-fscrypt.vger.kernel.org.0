Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34F12B534E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 21:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbgKPU4y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 15:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgKPU4x (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 15:56:53 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CD322078D;
        Mon, 16 Nov 2020 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560213;
        bh=UfGscBSkfIuefBDvy18V70t/6za7bSkxf+NkA+HlNjI=;
        h=From:To:Cc:Subject:Date:From;
        b=t7JTqmY5+NpzkDBT2RDHBvLZWcDc+LecIEeUPLdbZLvtDN/17rlS9vOw/v5LeY7/g
         Ws6lMQlaY/CG5Ass7FmrtBfLr4R/68o2bxHfRjFpD3NzVKl7wM6CQY02FtsQcRL7av
         9x4geYC+gZRu5YuTxhlLT5truiD/KvXR8rDFE950=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH v2 0/4] Add libfsverity_enable() and default params
Date:   Mon, 16 Nov 2020 12:56:24 -0800
Message-Id: <20201116205628.262173-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset adds wrappers around FS_IOC_ENABLE_VERITY to libfsverity,
makes libfsverity (rather than just the fsverity program) default to
SHA-256 and 4096-byte blocks, and makes the fsverity commands share code
to parse the libfsverity_merkle_tree_params.

This is my proposed alternative to Luca's patch
https://lkml.kernel.org/linux-fscrypt/20201113143527.1097499-1-luca.boccassi@gmail.com

Changed since v1:
  - Moved the default hash algorithm and block size handling into
    libfsverity.

Eric Biggers (4):
  programs/fsverity: change default block size from PAGE_SIZE to 4096
  lib/compute_digest: add default hash_algorithm and block_size
  lib: add libfsverity_enable() and libfsverity_enable_with_sig()
  programs/fsverity: share code to parse tree parameters

 include/libfsverity.h          | 83 +++++++++++++++++++++++++++++-----
 lib/compute_digest.c           | 27 ++++++-----
 lib/enable.c                   | 47 +++++++++++++++++++
 lib/lib_private.h              |  6 +++
 programs/cmd_digest.c          | 31 ++-----------
 programs/cmd_enable.c          | 34 +++-----------
 programs/cmd_sign.c            | 32 ++-----------
 programs/fsverity.c            | 35 ++++++++------
 programs/fsverity.h            | 21 ++++++---
 programs/test_compute_digest.c | 18 +++++---
 10 files changed, 201 insertions(+), 133 deletions(-)
 create mode 100644 lib/enable.c

-- 
2.29.2

