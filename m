Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E68A89C6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Sep 2019 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfIDPz2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Sep 2019 11:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfIDPz2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Sep 2019 11:55:28 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185FC22CED;
        Wed,  4 Sep 2019 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612527;
        bh=n7U+Trz0c3CupaEt0Y95vGbsTdrAvDWdLtPfgxXfzpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ooPaKpG4EfQxlnhrb+oug/4Gkvg130Oah08QtJ8g1Z+CaKl/o2H2wQyFBRzO4INqX
         f3A57a/AC0iSLOS4xAfnuTAzLsjuXsck0+6X7k78yyECvEYsUih7UlMKiMvQFTXa/n
         9+fg8ZRS+8m2Wp3Qsablkd27v6yfKJR6EvDIoRSQ=
Date:   Wed, 4 Sep 2019 08:55:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3] e2fsck: check for consistent encryption policies
Message-ID: <20190904155524.GA41757@gmail.com>
Mail-Followup-To: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <20190823162339.186643-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823162339.186643-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 23, 2019 at 09:23:39AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> By design, the kernel enforces that all files in an encrypted directory
> use the same encryption policy as the directory.  It's not possible to
> violate this constraint using syscalls.  Lookups of files that violate
> this constraint also fail, in case the disk was manipulated.
> 
> But this constraint can also be violated by accidental filesystem
> corruption.  E.g., a power cut when using ext4 without a journal might
> leave new files without the encryption bit and/or xattr.  Thus, it's
> important that e2fsck correct this condition.
> 
> Therefore, this patch makes the following changes to e2fsck:
> 
> - During pass 1 (inode table scan), create a map from inode number to
>   encryption policy for all encrypted inodes.  But it's optimized so
>   that the full xattrs aren't saved but rather only 32-bit "policy IDs",
>   since usually many inodes share the same encryption policy.  Also, if
>   an encryption xattr is missing, offer to clear the encrypt flag.  If
>   an encryption xattr is clearly corrupt, offer to clear the inode.
> 
> - During pass 2 (directory structure check), use the map to verify that
>   all regular files, directories, and symlinks in encrypted directories
>   use the directory's encryption policy.  Offer to clear any directory
>   entries for which this isn't the case.
> 
> Add a new test "f_bad_encryption" to test the new behavior.
> 
> Due to the new checks, it was also necessary to update the existing test
> "f_short_encrypted_dirent" to add an encryption xattr to the test file,
> since it was missing one before, which is now considered invalid.
> 

Any comments on this patch?

- Eric
