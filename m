Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692072DE238
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgLRLyo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Dec 2020 06:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgLRLyn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Dec 2020 06:54:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EE3C0617A7
        for <linux-fscrypt@vger.kernel.org>; Fri, 18 Dec 2020 03:54:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n3so4775013pjm.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 18 Dec 2020 03:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EMOyMmi5OQh1mMw6pWH3HTsh9nX0nJvvkb+01sG5L6Q=;
        b=OEqRBfN9ikmHv25/4WO0ioVGt+dtMVY9rOSKsI5lIuKBTvU4b+aYp4CCK82nWHGnS2
         rjLxRrIr/TQvF8gZBpg25+9PrMfCR6teCbq6+7toS/4enCVZg87drrlN9cOTyBOQ/+kZ
         0rIMRQV3Y7H5lJr5N7MFfK2xTyTOvpPt+kbgejrqeYe4xCTJCu26W53nxg3KXT55BVSj
         4BK1Bj6Ug2n5ufoys9NpoYzTBTU6KrsVsbBArZ6gDAycN/ciqAfBF73YU/QS6I6ENmpf
         DNXhWTbx7nR6WtTw9YBgslobxO3i88AalvYg1IuJaWD4eLKdTQbjO00LOIWzdBrcirIx
         UiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EMOyMmi5OQh1mMw6pWH3HTsh9nX0nJvvkb+01sG5L6Q=;
        b=ENJ1o4IxmTy9D/vDLknQy2+29tI72PeiFJe63DiXXUylhSsEqJU8huXDAwCQ4FTBuT
         9nF/68xZnoUonz5hot89l/lBGWPM05cgfddAg3AyzFKS39N+JK2cDW+IIHlGhLnEPdrl
         Msnp1x9bszoSPsc85d/BVWPhs6vbi0oRxNA2Wlzfajiq1wjxjggIgHzUG1PBQJDFPx01
         hhKpLAOK003ATm33swkk2hStarhFgKWoabPebDWFL1YSbbxR+CRvhm1W1XlI22JBX77n
         Aw+4ZWTktfvOs4jRSGyRASORlr5kSTilxIo5je5wHdNUc8eiZ6S2LBiea6DW1YWnLarc
         cDCQ==
X-Gm-Message-State: AOAM532nFqSwD9/3qT49O6ybDRQpvu0aJEbArBMAhNf8/LIABGtjSlnm
        EJeBd5GxkuJLh7vq8flGcIFBOw==
X-Google-Smtp-Source: ABdhPJwSlTiK2XI1930qTKhXQbTvQGl7TXUde9fI8+X06ym1hrnx7dRsCU6ClGix/2RdhYaIhNBIHQ==
X-Received: by 2002:a17:90a:5894:: with SMTP id j20mr3959568pji.107.1608292442787;
        Fri, 18 Dec 2020 03:54:02 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id gp14sm7862161pjb.6.2020.12.18.03.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 03:54:02 -0800 (PST)
Date:   Fri, 18 Dec 2020 11:53:58 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <X9yYVuuLt3/hL17J@google.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
 <X9t8y3rElyAPCLoD@google.com>
 <9a8d3ae2-a09f-f199-5cb1-48b1317b3d37@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8d3ae2-a09f-f199-5cb1-48b1317b3d37@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 18, 2020 at 05:02:23PM +0800, Chao Yu wrote:
> On 2020/12/17 23:44, Satya Tangirala wrote:
> > On Sat, Oct 10, 2020 at 05:53:06PM +0800, Chao Yu wrote:
> > > Why not using nid as DUN, then GC could migrate encrypted node block directly via
> > > meta inode's address space like we do for encrypted data block, rather than
> > > decrypting node block to node page and then encrypting node page with DUN of new
> > > blkaddr it migrates to.
> > > 
> > The issue is, the bi_crypt_context in a bio holds a single DUN value,
> > which is the DUN for the first data unit in the bio. blk-crypto assumes
> > that the DUN of each subsequent data unit can be computed by simply
> > incrementing the DUN. So physically contiguous data units can only be put
> > into the same bio if they also have contiguous DUNs. I don't know much
> > about nids, but if the nid is invariant w.r.t the physical block location,
> > then there might be more fragmentation of bios in regular read/writes
> 
> Correct, considering performance of in batch node flush, it will be better to
> use pba as IV value.
> 
> But, what's the plan about supporting software encryption for metadata? Current
> f2fs write flow will handle all operations which may encounter failure before
> allocating block address for node, if we do allocation first, and then use pba
> as IV to encrypt node block, it will be a little complicated to revert allocation
> if we fail to encrypt node block.
> 
Software encryption for metadata is supported through the blk-crypto
framework - so encryption will happen in the block layer, not the
filesystem layer. So there's nothing extra/special we need to do if
there's an encryption failure - an encryption failure is no different
from a read/write failure in a lower layer from f2fs' perspective.
