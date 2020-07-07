Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60738216BFC
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jul 2020 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGGLpN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Jul 2020 07:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgGGLpM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Jul 2020 07:45:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B949C08C5E0
        for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2020 04:45:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y3so47190213ybf.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2020 04:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LLQSBg64iwWxTtcpWWM6iR9wTgF8QbEH02Vy+2bg9Hg=;
        b=vaUinhNZkQN3RAVXNuIvu2m9UALKLZu6+nRg7EiTfijttvY5uvU/HlfVTs6MFI3BjD
         Er2jhbF7pByOmGUAkA0Rwjx6r1yRJYYD9O+cl25wvja83NKdtmmp1zngnkV02lhR5H60
         b5PjacpY1TP2NcUr9fiYcugKPCAjjR9rmlEhUHB0wiSX4QdOcSpvSGrvsQV0rT/nifCK
         2ZKi0Cmb2t3TuutVgBjI50QCH9omrBcU2W/h5TS/pS3DnoIpdnsJzSM7wmedPsCcY2wS
         ytB1vf691KXilc3nIafaO0kmcuwa8X3LA+tSoYg6SrxvtuS6RBnGMpkCLIhuojqhRuKM
         4b2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LLQSBg64iwWxTtcpWWM6iR9wTgF8QbEH02Vy+2bg9Hg=;
        b=LLdrKlElMXpJTVJyDgzTXOz03YVVm6hoUIVXUz6WBUmMirp4R69esL460uZdqxUVjn
         ethCM15lgZ6QcWA6b2aaDqWNmuY1Nt4rXyB4VtBjGx6PDaE4TWVljYXdZvHDMP9MU8/j
         jIsH818iyrP43+gPPszZ+2zLtYmjpa/HfCwqW0aad0ZAv8y4nZ0RCeLU6NAxkC4FT/ti
         klau66J7VORVBxAOmvAvazkXzxhYDjwBLJgdOv+TKw9WmQ4RPwPFLBZEpIxzWqBqZWUT
         QE71H+5m92YYoviohrAecMrt2OzzD4K23amX75fGs1ECy3SSYfgvPikcgLEICpT5t3vI
         9D5w==
X-Gm-Message-State: AOAM53376RMLhddc6bi+Lzum3maB6wxTVQfuq5nJ0nG/X3c65+ZtHhIJ
        M8O47wqythuLWy7hTOt1i5a7/3bDsQU=
X-Google-Smtp-Source: ABdhPJwLxIHBchd80Gve4mlw6g7Mb8civMvZG5ZcJoCOlzyO/mCAmx2JmX2IzIWBOuqsBIRGM+219TLjngU=
X-Received: by 2002:a25:b903:: with SMTP id x3mr32504935ybj.445.1594122311275;
 Tue, 07 Jul 2020 04:45:11 -0700 (PDT)
Date:   Tue,  7 Jul 2020 04:31:19 -0700
Message-Id: <20200707113123.3429337-1-drosen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v10 0/4] Prepare for upcoming Casefolding/Encryption patches
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This lays the ground work for enabling casefolding and encryption at the
same time for ext4 and f2fs. A future set of patches will enable that
functionality.

These unify the highly similar dentry_operations that ext4 and f2fs both
use for casefolding. In addition, they improve d_hash by not requiring a
new string allocation, and ensure we don't attempt to casefold the no-key
token of an encrypted filename.

Daniel Rosenberg (4):
  unicode: Add utf8_casefold_hash
  fs: Add standard casefolding support
  f2fs: Use generic casefolding support
  ext4: Use generic casefolding support

 fs/ext4/dir.c           | 64 +--------------------------
 fs/ext4/ext4.h          | 12 ------
 fs/ext4/hash.c          |  2 +-
 fs/ext4/namei.c         | 20 ++++-----
 fs/ext4/super.c         | 12 +++---
 fs/f2fs/dir.c           | 83 ++++-------------------------------
 fs/f2fs/f2fs.h          |  4 --
 fs/f2fs/super.c         | 10 ++---
 fs/f2fs/sysfs.c         | 10 +++--
 fs/libfs.c              | 96 +++++++++++++++++++++++++++++++++++++++++
 fs/unicode/utf8-core.c  | 23 +++++++++-
 include/linux/f2fs_fs.h |  3 --
 include/linux/fs.h      | 16 +++++++
 include/linux/unicode.h |  3 ++
 14 files changed, 174 insertions(+), 184 deletions(-)

-- 
2.27.0.212.ge8ba1cc988-goog

