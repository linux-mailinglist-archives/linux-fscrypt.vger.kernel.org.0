Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F153D2620
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Jul 2021 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhGVOIK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Jul 2021 10:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232328AbhGVOIK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Jul 2021 10:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F21360FEE;
        Thu, 22 Jul 2021 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626965325;
        bh=kjIiN475TqYty0z7PIG+/pMDUBt+OSnFGGmVVgMKoNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tc+SdqxggbbqbTwN0onZFGwh5ZmEywzzNR89LpVLby39UCAWx4h4yqlPURhVbOncf
         KO6YdbeB4zmYYs42oENDY/fKUz+QoAIV4OnlbOnGxvVvgR2wJ6x43sdIHiIF9dLVfG
         g7ILJbQio/iTJkibMqB7mJ0xtUe17Fva3M2NRpP5Tdgn73LqOJgshreiHi490eXmP0
         50PjB4kG+vNuP/UHXTJSqknemuwEn8dw7XKd8S10eR1NRH+Oqy1g0k9EMo+iZXzKea
         1TuenfuARM8NDdS38D33/4/2W8QGWzkHysasB3zq2IeE6c311F0/CwDQLQKIPRPh0w
         Khg5eR81VTn5Q==
Date:   Thu, 22 Jul 2021 07:48:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Satya Tangirala <satyat@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v9 0/9] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <YPmFSw4JbWnIozSZ@gmail.com>
References: <20210604210908.2105870-1-satyat@google.com>
 <CAF2Aj3h-Gt3bOxH4wXB7aeQ3jVzR3TEqd3uLsh4T9Q=e6W6iqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF2Aj3h-Gt3bOxH4wXB7aeQ3jVzR3TEqd3uLsh4T9Q=e6W6iqQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Lee,

On Thu, Jul 22, 2021 at 12:23:47PM +0100, Lee Jones wrote:
> 
> No review after 7 weeks on the list.
> 
> Is there anything Satya can do to help expedite this please?
> 

This series is basically ready, but I can't apply it because it depends on the
other patch series
"[PATCH v4 0/9] ensure bios aren't split in middle of crypto data unit"
(https://lkml.kernel.org/linux-block/20210707052943.3960-1-satyaprateek2357@gmail.com/T/#u).
I will be re-reviewing that other patch series soon, but it primary needs review
by the people who work more regularly with the block layer, and it will have to
go in through the block tree (I can't apply it to the fscrypt tree).

The original version of this series didn't require so many block layer changes,
but it would have only allowed direct I/O with user buffer pointers aligned to
the filesystem block size, which was too controversial with other filesystem
developers; see the long discussion at
https://lkml.kernel.org/linux-fscrypt/20200720233739.824943-1-satyat@google.com/T/#u.

In addition, it was requested that we not add features to the "legacy" direct
I/O implementation (fs/direct-io.c), so I have a patch series in progress
"[PATCH 0/9] f2fs: use iomap for direct I/O"
(https://lkml.kernel.org/linux-f2fs-devel/20210716143919.44373-1-ebiggers@kernel.org/T/#u)
which will change f2fs to use iomap.

Also please understand that Satya has left Google, so any further work from him
on this is happening on a personal capacity in his free time.

- Eric
