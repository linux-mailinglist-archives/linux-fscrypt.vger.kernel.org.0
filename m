Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123E21E1151
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 May 2020 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390990AbgEYPK6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 May 2020 11:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390947AbgEYPK6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 May 2020 11:10:58 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF552073B;
        Mon, 25 May 2020 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590419457;
        bh=kWDchJjRAEJVbNKSENl4Ienf/7DpzmUVEB1I8GSDrEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fpCzqg8Tp9ZS4H8j9ZJ4ccZdUup73PHLuYGsjSAm4AUzRDJ5CyxKsrCnhsLNShcme
         jqzUNZEUdhHw3s5Zl2/m1xK4+nyFHwrEDSsdJOC9bb1E2W55jF1nxTUhuj/rJXhZKF
         iCSCqKIKFFwEcZbPkJAFH54VOxZUQAeYk8NY2vqE=
Date:   Mon, 25 May 2020 08:10:57 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [f2fs-dev] [PATCH 3/4] f2fs: rework filename handling
Message-ID: <20200525151057.GB55033@google.com>
References: <20200507075905.953777-1-ebiggers@kernel.org>
 <20200507075905.953777-4-ebiggers@kernel.org>
 <9c18ded1-06cb-1187-1eac-5ba354eebee1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c18ded1-06cb-1187-1eac-5ba354eebee1@huawei.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 05/25, Chao Yu wrote:
> On 2020/5/7 15:59, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Rework f2fs's handling of filenames to use a new 'struct f2fs_filename'.
> > Similar to 'struct ext4_filename', this stores the usr_fname, disk_name,
> > dirhash, crypto_buf, and casefolded name.  Some of these names can be
> > NULL in some cases.  'struct f2fs_filename' differs from
> > 'struct fscrypt_name' mainly in that the casefolded name is included.
> > 
> > For user-initiated directory operations like lookup() and create(),
> > initialize the f2fs_filename by translating the corresponding
> > fscrypt_name, then computing the dirhash and casefolded name if needed.
> > 
> > This makes the dirhash and casefolded name be cached for each syscall,
> > so we don't have to recompute them repeatedly.  (Previously, f2fs
> > computed the dirhash once per directory level, and the casefolded name
> > once per directory block.)  This improves performance.
> > 
> > This rework also makes it much easier to correctly handle all
> > combinations of normal, encrypted, casefolded, and encrypted+casefolded
> > directories.  (The fourth isn't supported yet but is being worked on.)
> > 
> > The only other cases where an f2fs_filename gets initialized are for two
> > filesystem-internal operations: (1) when converting an inline directory
> > to a regular one, we grab the needed disk_name and hash from an existing
> > f2fs_dir_entry; and (2) when roll-forward recovering a new dentry, we
> > grab the needed disk_name from f2fs_inode::i_name and compute the hash.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks, but it's quite late to rebase stacked patches for this update when
considering we have only 1 week for pull request. :)

> 
> Thanks,
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
