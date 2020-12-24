Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB7F2E25E4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Dec 2020 11:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgLXKOp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Dec 2020 05:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgLXKOo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Dec 2020 05:14:44 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2158C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 24 Dec 2020 02:14:04 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id p18so1297847pgm.11
        for <linux-fscrypt@vger.kernel.org>; Thu, 24 Dec 2020 02:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q9UsCaq19AZa2ox78ufqQlJ4vDMf1SOgSIwUYk8kOCo=;
        b=nnVR1FwZPyr5Jv+aOxCHm7Aof9HxrtQNlgOKRlGUDHz5pKtlE2J/rjkv65PbbCLhqL
         3Wkx2Fcy1sgW6YJ4aYIg5JrGItOiS33slLlqlRp7lXNQSBSLJ3fePjTopNThsta+If9b
         smdSizxQ8z9rguoYkjUS2h/P0pLjVgpUtn8cfDvBF73YOeH7wsRA05C8Gy8nrFjy8X7p
         c4p7jGZtAINV/bPPAhXrD9YmQeI/ABvOE1YzeA2NfUN8HjwLVaUPrzUsD6bXNCyB5nbZ
         uQuCImdT5j1AL99flbVaJAIBs7DXGyp12cGhWueFRsX0oM710qfgLK4Hm7hykyyzlyRi
         RJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q9UsCaq19AZa2ox78ufqQlJ4vDMf1SOgSIwUYk8kOCo=;
        b=AsC6DZ/A9ygB6zNlnikOWBxvLWmQuxLzSx3+AUslFB4FMH9aPqP2Cq+X1MjylhJBvJ
         JwqZmwrPr8VAwqL/g3jJNdWaFdA4y4ge13kyWbe1KSLGURtkGK2bK/hVg3g6L5EH5gP2
         DHEpsidajZ+GxwTR5w5hEx8ZILqAPb0yZJw0YD2pp/3SgYbcfI0LMsGYAbitO2747ujI
         xw3WU9CAWVZjjAYIs4ooSUwCtx1jnFWGoCPc+5CD+UeZPB0c226rPLER+KVyKqrvsy87
         eL4t7+U160vA+WI/0jYES1vPh0VOjkqyjF/yO11Jh8X+MBSwZHzzoYIx+HYJYH4vfZgJ
         5NPg==
X-Gm-Message-State: AOAM532zGc4xpzl12UutuoHhwqMv62+zt6wc6EbxetJYOVqL8g+Qn9x1
        5nSjSH99ULbEor4YWCF6yi1/2A==
X-Google-Smtp-Source: ABdhPJyexoKUu+zPfra+YE0JFY+DWyUSw9Y07WCOTW0eNxMYWN4AnFqYZKe5JyK9foCHkAbPt9mYBw==
X-Received: by 2002:a63:e02:: with SMTP id d2mr27908916pgl.34.1608804844027;
        Thu, 24 Dec 2020 02:14:04 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id g202sm25224414pfb.196.2020.12.24.02.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 02:14:03 -0800 (PST)
Date:   Thu, 24 Dec 2020 10:13:59 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <X+Rp579fp5sMDvSP@google.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
 <X9t8y3rElyAPCLoD@google.com>
 <9a8d3ae2-a09f-f199-5cb1-48b1317b3d37@huawei.com>
 <X9yYVuuLt3/hL17J@google.com>
 <c08aadef-47a7-f6fc-c2fa-11393ca938e8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c08aadef-47a7-f6fc-c2fa-11393ca938e8@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 22, 2020 at 07:47:45PM +0800, Chao Yu wrote:
> On 2020/12/18 19:53, Satya Tangirala wrote:
> > On Fri, Dec 18, 2020 at 05:02:23PM +0800, Chao Yu wrote:
> > > But, what's the plan about supporting software encryption for metadata? Current
> > > f2fs write flow will handle all operations which may encounter failure before
> > > allocating block address for node, if we do allocation first, and then use pba
> > > as IV to encrypt node block, it will be a little complicated to revert allocation
> > > if we fail to encrypt node block.
> > > 
> > Software encryption for metadata is supported through the blk-crypto
> 
> blk-crypto will encrypt all data in filesystem, if FBE is enabled, data may
> be encrypted twice?
blk-crypto will only encrypt bios as directed to do so by the encryption
context set on the bio. That encryption context is constructed by the
submitter of the bio - in our case, the submitter is the filesystem.
So the filesystem decides which bio gets encrypted with
which key/algorithm/etc (and in the current implementation, each bio
only supports a single bi_crypt_context, so *only one* layer of
encryption is possible with blk-crypto anyway). So no, data won't be
encrypted twice, because F2FS/fscrypt ensure that it does not (and the
filesystem knows exactly which blocks need metadata encryption, and
which blocks need FBE).
> 
> And why not supporting hardware encryption for metadata in blk-crypto? then
> both f2fs and ext4 can use inline-encryption based blk-crypto?
>
I may be misunderstanding what you're asking, but I think you're asking
why not make blk-crypto do metadata encryption (without explicit
involvement from filesystems)? Or more generally, why not do metadata
encryption below the filesystem layer?

As mentioned above, the filesystem is what knows which blocks need to be
metadata encrypted and which blocks need to be FBE encrypted (or even
just read without any encryption at all) - the block layer doesn't have
this information, and so can't effectively decide which blocks to use
the metadata encryption key on. Fwiw, Android does take a somewhat
similar approach to what you're suggesting here (I explain more in
detail in the cover letter for v2 of this patch series at
https://lore.kernel.org/linux-fscrypt/20201217150435.1505269-1-satyat@google.com/
). In Android, we have a new DM target (called dm-default-key) that adds
an encryption context to any bio that doesn't already have an encryption
context - so the assumption in general is that if the filesystem wants to
use an FBE key, it would have already set the encryption context on the
bio, so if a bio reaches dm-default-key without an encryption context,
it must mean that it needs metadata encryption. However, that assumption
doesn't always hold because F2FS sometimes needs to read the ciphertext
of FBE files without having the file's FBE key available - in those
situations, F2FS will send a bio without any encryption context, but
will also tell dm-default-key to *not* add the metadata encryption
context. That's a layering violation, which is why I'm not using that
approach here.

Does that answer your question? Or am I misunderstanding what you're
asking?
> Thanks,
> 
> > framework - so encryption will happen in the block layer, not the
> > filesystem layer. So there's nothing extra/special we need to do if
> > there's an encryption failure - an encryption failure is no different
> > from a read/write failure in a lower layer from f2fs' perspective.
> > .
> > 
