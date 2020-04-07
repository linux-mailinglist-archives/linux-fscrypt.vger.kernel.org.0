Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACF81A0699
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Apr 2020 07:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgDGFcP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Apr 2020 01:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGFcP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Apr 2020 01:32:15 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B3720692;
        Tue,  7 Apr 2020 05:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586237534;
        bh=DHYXASYcZ8yXq73Zg/kE/PSoOS4WftRp2BixKT9v1FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ow/+Go8p0vo9JlC9GYiA0TiX59HqsUqAzdVFilUCK68/rcSIr9P/7Vv/41TsUw308
         dAbTEM86GrY6RndcCytF4FWwx8Ja2flgj70XQQahDkBMhvCu5nA2CvDiGVWAhHrSwz
         Xe7kUKPugiT61JMeku/AAB5hK2V8jRJgH4MWVLtk=
Date:   Mon, 6 Apr 2020 22:32:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Message-ID: <20200407053213.GC102437@sol.localdomain>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 01, 2020 at 08:19:38PM -0600, Andreas Dilger wrote:
> On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The stable_inodes feature is intended to indicate that it's safe to use
> > IV_INO_LBLK_64 encryption policies, where the encryption depends on the
> > inode numbers and thus filesystem shrinking is not allowed.  However
> > since inode numbers are not unique across filesystems, the encryption
> > also depends on the filesystem UUID, and I missed that there is a
> > supported way to change the filesystem UUID (tune2fs -U).
> > 
> > So, make 'tune2fs -U' report an error if stable_inodes is set.
> > 
> > We could add a separate stable_uuid feature flag, but it seems unlikely
> > it would be useful enough on its own to warrant another flag.
> 
> What about having tune2fs walk the inode table checking for any inodes that
> have this flag, and only refusing to clear the flag if it finds any?  That
> takes some time on very large filesystems, but since inode table reading is
> linear it is reasonable on most filesystems.
> 

I assume you meant to make this comment on patch 2,
"tune2fs: prevent stable_inodes feature from being cleared"?

It's a good suggestion, but it also applies equally to the encrypt, verity,
extents, and ea_inode features.  Currently tune2fs can't clear any of these,
since any inode might be using them.

Note that it would actually be slightly harder to implement your suggestion for
stable_inodes than those four existing features, since clearing stable_inodes
would require reading xattrs rather than just the inode flags.

So if I have time, I can certainly look into allowing tune2fs to clear the
encrypt, verity, extents, stable_inodes, and ea_inode features, by doing an
inode table scan to verify that it's safe.  IMO it doesn't make sense to hold up
this patch on it, though.  This patch just makes stable_inodes work like other
ext4 features.

- Eric
