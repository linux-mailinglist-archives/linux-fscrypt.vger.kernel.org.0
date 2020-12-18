Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA81C2DDEB2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 07:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbgLRGmR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Dec 2020 01:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732678AbgLRGmR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Dec 2020 01:42:17 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FEC0617A7
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 22:41:37 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s2so875079plr.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 22:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uIQfDC/Ph2Mj0AwvwcwaxZ4M1p4iwfh+sd2KyYnMW3k=;
        b=LjjpzATQOmCAs83P1DO8IQmmLQ5KfH54zPhW0XNB0isZ4eUiwadcvt8X3V8jxVEgVq
         3JzF6nFC3ReDYjOEBB5iFgXVEr4nMpkPl9CFNjmOcHmbHFBM3NvAqmQoH55V8sgOvL52
         77B666yUzB7g5USJEIGnXtlvJdjPMr0mUpF4jAPctgkoTODoszFVebj/xtX/wiS/wlb0
         JmwAY54BqJdKEx+yspPGrf07gT0KqMLqzwmjZ4QRhwvCYMyzogLYYbaHbmi0+wP3roe2
         qzRqr4DSoWX4JWdhkLXdTWsxnAeB6kF/xND7JvK2p9tL47XxD7yIGtJ0yCLIvgTPNVT4
         k97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uIQfDC/Ph2Mj0AwvwcwaxZ4M1p4iwfh+sd2KyYnMW3k=;
        b=MPTEU9xCJTnW7PYnxgSW8HlhrkWakUa2peuQxk603AUZ7ICaOQCV9BlaGFSP+Nw+P3
         IQL4U55MgMhm5iwk/OGnduU9q8YSmxna+3qO9UBJj56mXqNdwdcTiIQlbi/Wx//b+zv6
         Op25Q2PutRD/B1k+zIMzFzhIfcF5SmQm7KOvvETb/Wr1FiXxd0zqtJQo62tJIrvOUsyT
         TVfudUIvQamRwMZbo8/dMLN7kqvEVK40lzXDY1U00jy2MJ+w4VVEbryE80T0V8hk5oHs
         qiRL3ryx44YLKw3LjSEmAS9J96CLcsMb+r3BtE5WHligJsEUg8c5rHOrIzrIWxxSzU3c
         i8Xw==
X-Gm-Message-State: AOAM530G2acb2/Q3xuizDj/O/N+OsrEtWaI7/+5iMqk8N04DYaLc6Ufa
        7vwYPgdXPKhwCCZvgNIuwXU4qA==
X-Google-Smtp-Source: ABdhPJwAoMU/wCqmbRu4OtB/oMycvpD9J5EH+p7/2JXTxgvdDwDS9PQssUbTb+zDVZBBLi1ozOovgQ==
X-Received: by 2002:a17:902:8bc5:b029:dc:1e79:e746 with SMTP id r5-20020a1709028bc5b02900dc1e79e746mr2649165plo.77.1608273696432;
        Thu, 17 Dec 2020 22:41:36 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id bg20sm6666431pjb.6.2020.12.17.22.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 22:41:35 -0800 (PST)
Date:   Fri, 18 Dec 2020 06:41:32 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/1] userspace support for F2FS metadata encryption
Message-ID: <X9xPHDPhsOfGYIgv@google.com>
References: <20201005074133.1958633-1-satyat@google.com>
 <X9uF9kNjWFq8KlL9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9uF9kNjWFq8KlL9@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 08:23:18AM -0800, Jaegeuk Kim wrote:
> Hi Satya,
> 
> Could you please consider to rebase the patches on f2fs-tools/dev branch?
> I've applied compression support which will have some conflicts with this
> series. And, could you check this works with multi-partition support?
> 
Sure, I'll do that! I sent out v2 of this patch series earlier today,
so would you want me to send out a rebased version asap? or when
I send out v3?

Also, newbie question - multi-partition support is the same as
multi-device support, right?
> Thanks,
> 
> On 10/05, Satya Tangirala wrote:
> > The kernel patches for F2FS metadata encryption are at:
> > 
> > https://lore.kernel.org/linux-fscrypt/20201005073606.1949772-4-satyat@google.com/
> > 
> > This patch implements the userspace changes required for metadata
> > encryption support as implemented in the kernel changes above. All blocks
> > in the filesystem are encrypted with the user provided metadata encryption
> > key except for the superblock (and its redundant copy). The DUN for a block
> > is its offset from the start of the filesystem.
> > 
> > This patch introduces two new options for the userspace tools: '-A' to
> > specify the encryption algorithm, and '-M' to specify the encryption key.
> > mkfs.f2fs will store the encryption algorithm used for metadata encryption
> > in the superblock itself, so '-A' is only applicable to mkfs.f2fs. The rest
> > of the tools only take the '-M' option, and will obtain the encryption
> > algorithm from the superblock of the FS.
> > 
> > Limitations: 
> > Metadata encryption with sparse storage has not been implemented yet in
> > this patch.
> > 
> > This patch requires the metadata encryption key to be readable from
> > userspace, and does not ensure that it is zeroed before the program exits
> > for any reason.
> > 
> > Satya Tangirala (1):
> >   f2fs-tools: Introduce metadata encryption support
> > 
> >  fsck/main.c                   |  47 ++++++-
> >  fsck/mount.c                  |  33 ++++-
> >  include/f2fs_fs.h             |  10 +-
> >  include/f2fs_metadata_crypt.h |  21 ++++
> >  lib/Makefile.am               |   4 +-
> >  lib/f2fs_metadata_crypt.c     | 226 ++++++++++++++++++++++++++++++++++
> >  lib/libf2fs_io.c              |  87 +++++++++++--
> >  mkfs/f2fs_format.c            |   5 +-
> >  mkfs/f2fs_format_main.c       |  33 ++++-
> >  9 files changed, 446 insertions(+), 20 deletions(-)
> >  create mode 100644 include/f2fs_metadata_crypt.h
> >  create mode 100644 lib/f2fs_metadata_crypt.c
> > 
> > -- 
> > 2.28.0.806.g8561365e88-goog
