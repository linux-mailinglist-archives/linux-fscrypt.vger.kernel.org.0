Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64F58A503
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfHLR5P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfHLR5O (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:14 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E5320663;
        Mon, 12 Aug 2019 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632633;
        bh=GiVAVhH+nPdk1UWotaUHBWK0S43N/8KUvkvXHy1BLYo=;
        h=From:To:Cc:Subject:Date:From;
        b=QSb8/eaChRb8WrbrxfPEIM9JPkLZHHaJH+FToyjTGG2VV2Sfj1FcgDlXL/v+VRrcX
         69S0YkawGMSzkx+X8TedLqLx5nbIbk5uUj99QTZidI0n5WfisqA4Rf5ZHALWb1cwA9
         Hv4G4p0dN2E+J2Ure2EPqrnQTxGU5Q1z54uolNpg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 0/8] xfsprogs: support fscrypt API additions in xfs_io
Date:   Mon, 12 Aug 2019 10:56:26 -0700
Message-Id: <20190812175635.34186-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset updates xfs_io to support the API additions from the
kernel patchset "[PATCH v8 00/20] fscrypt: key management improvements"
https://lkml.kernel.org/linux-fsdevel/20190805162521.90882-1-ebiggers@kernel.org/T/#u

Commands are added to wrap the new ioctls for managing filesystem
encryption keys.  Also, the existing 'get_encpolicy' and 'set_encpolicy'
commands are updated to support v2 encryption policies.

The purpose of all this is to allow xfstests to test the new APIs.

Note: currently only ext4, f2fs, and ubifs support encryption.  But I
was told previously that since the fscrypt API is generic and may be
supported by XFS in the future, the command-line wrappers for the
fscrypt ioctls should be in xfs_io rather than in fstests directly
(https://marc.info/?l=fstests&m=147976255831951&w=2).

We'll want to wait for the kernel patches to be mainlined before merging
this, but I'm making it available now for any early feedback.

This patchset applies to xfsprogs v5.2.0.  It can also be retrieved from tag
"fscrypt-key-mgmt-improvements_2019-08-12" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfsprogs-dev.git

Eric Biggers (8):
  xfs_io/encrypt: remove unimplemented encryption modes
  xfs_io/encrypt: update to UAPI definitions from Linux v5.4
  xfs_io/encrypt: add new encryption modes
  xfs_io/encrypt: extend 'get_encpolicy' to support v2 policies
  xfs_io/encrypt: extend 'set_encpolicy' to support v2 policies
  xfs_io/encrypt: add 'add_enckey' command
  xfs_io/encrypt: add 'rm_enckey' command
  xfs_io/encrypt: add 'enckey_status' command

 io/encrypt.c      | 786 ++++++++++++++++++++++++++++++++++++++++------
 man/man8/xfs_io.8 |  70 ++++-
 2 files changed, 750 insertions(+), 106 deletions(-)

-- 
2.23.0.rc1.153.gdeed80330f-goog

