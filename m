Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD121A814
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 21:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGITsD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 15:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGITr5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 15:47:57 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E9AC08C5DD
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 12:47:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h75so2015924pfe.23
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 12:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OQlFlzqp7cgxbEDAcFcy1Mp/9MDoNdc1mBQkMnvEjS8=;
        b=pBZbi74/hZ9MKsVQolBdjXjTOO8KKn/3Z56LfSGw1BYIJbckz8I6p+Grrnj++3VaqI
         Wfd7CJ40NdzKxB9/ChwQTaq+jFFu84vkcBwJdZ3qR5ZYg9tvRya9kcEriBdzZmqHUquz
         ra78LhjLSBN0thXrH9MXImFbLdmrxwobSlfEXgCfjXHziseJKpNM7ZmDmUliCJd07P1g
         NiwyQ1h6y3r/5FidO0wXZagVk1tnMpEVSZz+DzHUTgViL04XFNPAvmlS6EvBM2XHRtvw
         9R+IzEJYFfk/49VWx3x2fGfrhavRhEiQHpOYtFKVBFBysKZcVFW90TqQJa2sJwWmA261
         0ovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OQlFlzqp7cgxbEDAcFcy1Mp/9MDoNdc1mBQkMnvEjS8=;
        b=fGPwWIjWL4rgCmrTuQW3Ia90N336TJ8m9TTVoOrAZZVXr8uPQNJaPqIOIP65uqj0to
         Mom1Q20OJZF+PyfqHWaH32QRjuPXiaartnTWItDZjtA7MieWi5OyIjmYNK7u6+NcGZb3
         7iUJKHLwLsch/vRL78ZTWZHHGiGb9LB3rXqIUwQ0+G8lo8DBYgUmupnzLgDL8rMkEXGY
         OIGaUzDFOSp9M1ZJs5vjYc78D+ewlpJDZFuvGAE0GZZdbMc9S0AgeJzUjpZA08subjZ3
         1xwAeuod2d77yPaqnnGh1knv0N9THk2/wxU6KBEiyyfmSkzvn643B4LVw2pFbsV+4yw2
         Adug==
X-Gm-Message-State: AOAM530g3ovgoJo7ZAUJWB71XCKtEfqO+bnDl+LrJG4uM07XAVdJMZrv
        eh23MEhXDtdFy49v/ftbg9+f1xwe18E6b9/cCnmEnuvUaevOTICAUsP1yp4tbK1xQOMga49VVDr
        99LFkcKgvOcfZYnesB/IDJFEF28HITWBIZG0f5z9kCxwAz6d2M49sGqcxB3vE5JyYaOSOJhQ=
X-Google-Smtp-Source: ABdhPJyPuBGtLJ2QIfaP80rWb4N1NQC5Ht7OHXhJqVfgNx6APnNpuuj6IT4dY+awLOKpAY/PJNhCp6wKhKM=
X-Received: by 2002:a17:90a:1fcb:: with SMTP id z11mr770921pjz.1.1594324075443;
 Thu, 09 Jul 2020 12:47:55 -0700 (PDT)
Date:   Thu,  9 Jul 2020 19:47:46 +0000
Message-Id: <20200709194751.2579207-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 0/5] add support for direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch series adds support for direct I/O with fscrypt using
blk-crypto. It has been rebased on fscrypt/inline-encryption.

Patch 1 adds two functions to fscrypt that need to be called to determine
if direct I/O is supported for a request.

Patches 2 and 3 wire up direct-io and iomap respectively with the functions
introduced in Patch 1 and set bio crypt contexts on bios when appropriate
by calling into fscrypt.

Patches 4 and 5 allow ext4 and f2fs direct I/O to support fscrypt without
falling back to buffered I/O.

This patch series was tested by running xfstests with test_dummy_encryption
with and without the 'inlinecrypt' mount option, and there were no
meaningful regressions. The only regression was for generic/587 on ext4,
but that test isn't compatible with test_dummy_encryption in the first
place, and the test "incorrectly" passes without the 'inlinecrypt' mount
option - a patch will be sent out to exclude that test when
test_dummy_encryption is turned on with ext4 (like the other quota related
tests that use user visible quota files).

Eric Biggers (5):
  fscrypt: Add functions for direct I/O support
  direct-io: add support for fscrypt using blk-crypto
  iomap: support direct I/O with fscrypt using blk-crypto
  ext4: support direct I/O with fscrypt using blk-crypto
  f2fs: support direct I/O with fscrypt using blk-crypto

 fs/crypto/crypto.c       |  8 +++++
 fs/crypto/inline_crypt.c | 72 ++++++++++++++++++++++++++++++++++++++++
 fs/direct-io.c           | 15 ++++++++-
 fs/ext4/file.c           | 10 +++---
 fs/f2fs/f2fs.h           |  4 ++-
 fs/iomap/direct-io.c     |  8 +++++
 include/linux/fscrypt.h  | 19 +++++++++++
 7 files changed, 130 insertions(+), 6 deletions(-)

-- 
2.27.0.383.g050319c2ae-goog

