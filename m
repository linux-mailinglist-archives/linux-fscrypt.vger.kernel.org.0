Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB732CE344
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Dec 2020 00:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbgLCX6K (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Dec 2020 18:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731902AbgLCX6J (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Dec 2020 18:58:09 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3712DC061A54
        for <linux-fscrypt@vger.kernel.org>; Thu,  3 Dec 2020 15:57:24 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h7so2847022pjk.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 03 Dec 2020 15:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r3iPhcdxqx2nLoy8M4vQlPfXI0ncDfSnm735uhVf2l4=;
        b=d/iGiH3bSWJT1Ok5lWKWHJazX8nRtciZ2SkqFh9sl21toJzUW3UCNhveT2aQoj8ogX
         t8QbwYZcTOMwT9M0ATD7aMBq57xHvZ7nJiVMEg3iEVnQTpCHlkNcA7YXikSh4EnjqcWB
         stzhhr9yJFM5pdjrLS5OWbEUCKgdH29INZ2zyjE9xeUW1FcIhd4Q4iL/Nw/f2/GACHgg
         aDvQXBk87ZODzpcpMKE0pHui+1uEyo2klybaJRW6e4JiWbP1cTiTkrjTlZ3NjpWie3B3
         x/eCp8DtTgOmUW9I+63inDoSSbf7/2l1mfqTeH2KsYFmct06Vi5iCwJMCrjqpL36/MTJ
         o1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r3iPhcdxqx2nLoy8M4vQlPfXI0ncDfSnm735uhVf2l4=;
        b=jRXBSBQ1mtNAxgAJXzm+LSqX8LbE3gitF+ZKV816jcaAiSUCNCFCTKGdZJ9p49aSuZ
         oQSRJWF6QaLV/CbirlLWb64PqhXVK5OWuwqVjXHeb8zXaLKYBmsQYmocAxz667+cwWSA
         tbuyYXWibPz3DHijX7VU9nUVoomD0JT+WomyIJ5vzoSgdDwySFcIq8/QB4El/hhISvtV
         nLGXsWprM0Act05ZJ7zXyVmhBShi4wVngErD3gM3BTG9k8iHGOXeZVMNPyKIBXvU3Yic
         J5nsjRsvRIYWMVE1FL66Fs8RSrC5Xtqsqwn4DY6k052+lk/J5sA5pMmmUxeyPSRYtNF5
         PJCQ==
X-Gm-Message-State: AOAM53065BFZKvGwkPEpN0DcEhYjBEdjuWyWZIOIB56z6oSmZZ+InFeC
        82j6qh8wiup2oX7Ng2RialCQHA==
X-Google-Smtp-Source: ABdhPJzNGZB0k9vwg17W0yzDJC60tNxzVr36GnJUcQmz8GR8UJ0qGwRTf4QVg019AhXRMWmMtQBlhw==
X-Received: by 2002:a17:90b:4c41:: with SMTP id np1mr1449158pjb.186.1607039843547;
        Thu, 03 Dec 2020 15:57:23 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id q23sm2903613pfg.18.2020.12.03.15.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 15:57:22 -0800 (PST)
Date:   Thu, 3 Dec 2020 23:57:18 +0000
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <X8l7XgWNz5sO/LQ6@google.com>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117171526.GD445084@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117171526.GD445084@mit.edu>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 12:15:26PM -0500, Theodore Y. Ts'o wrote:
> What is the expected use case for Direct I/O using fscrypt?  This
> isn't a problem which is unique to fscrypt, but one of the really
> unfortunate aspects of the DIO interface is the silent fallback to
> buffered I/O.  We've lived with this because DIO goes back decades,
> and the original use case was to keep enterprise databases happy, and
> the rules around what is necessary for DIO to work was relatively well
> understood.
> 
> But with fscrypt, there's going to be some additional requirements
> (e.g., using inline crypto) required or else DIO silently fall back to
> buffered I/O for encrypted files.  Depending on the intended use case
> of DIO with fscrypt, this caveat might or might not be unfortunately
> surprising for applications.
> 
> I wonder if we should have some kind of interface so we can more
> explicitly allow applications to query exactly what the requirements
> might be for a particular file vis-a-vis Direct I/O.  What are the
> memory alignment requirements, what are the file offset alignment
> requirements, what are the write size requirements, for a particular
> file.
> 
(Credit to Eric for the description of use cases that I'm
copying/summarizing here).
The primary motivation for this patch series is Android - some devices use
zram with cold page writeback enabled to an encrypted swap file, so direct
I/O is needed to avoid double-caching the data in the swap file. In
general, this patch is useful for avoiding double caching any time a
loopback device is created in an encrypted directory. We also expect this
to be useful for databases that want to use direct I/O but also want to
encrypt data at the FS level.

I do think having a good way to tell userspace about the DIO requirements
would be great to have. Userspace does have ways to access to most, but not
all, of the information it needs to figure out the DIO requirements (I
don't think userspace has any way of figuring out if inline encryption
hardware is available right now), so it would be nice if there was a
good/unified API for getting those requirements.

Do you think we'll need that before these patches can go in though? I do
think the patches as is are useful for their primary use case even without
the ability to explicitly query for the DIO requirements, because Android
devices are predictable w.r.t inline encryption support (devices ship with
either blk-crypto-fallback or have inline encryption hardware, and the
patchset's requirements are met in either case). And even when used on
machines without such predictability, this patch is at worst the same as
the current situation, and at best an improvement.
> 						- Ted
