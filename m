Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6BB2DD484
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgLQPo5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbgLQPo4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:44:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF12CC0617B0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:44:16 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p18so8982599pgm.11
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YJBDB26f+rldjj+37sZsFkhqfX20jU8Ct5zIftBgtXU=;
        b=hhgQdzkn4X5+KE3TaD5QBQ1MyViUTs8nYplu8dVBPHSodPeadQRmtzi7/kzdtKtYaZ
         0wAJ8pgg49ZD77BJ9l1Ox3cSZORcPe3dtTBc93E4UcaIAgKtrhE4XyVs2TwCPazOThkf
         pxGK5Wn5t3y+kAtOKYcZWGDnQm6S+0Yepfe4ywYHDSy1bblhT/hVyLsE9LnijR/u1u7f
         /NzKEH1QZG+qwFp6mQe8zWs2chV4KT/8G2+EDYX8bVMGfYFH2hbnuxAjp97t2yJrcAeP
         WYm7+5/1TLeOkchXIT133Kpsn1Ocn5IZvbwfBX9cvdHEucf3aIzxT3xRH2LpBX1JzDn+
         /INg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YJBDB26f+rldjj+37sZsFkhqfX20jU8Ct5zIftBgtXU=;
        b=Inom9Nsk17CiE0JDQL26qq0gWHtzww1aNmB5jwVSEoVmCYjcLbfOLViXdKpmHFuBh9
         ce28r/LinADmEyClEHWgVJtT0RBjHTLOj5/Z2O2ON8zezqSO3pz6+VTLVfBZ+H3g8Tz1
         3AyjZeaULZJrRd3j0OoVh4ll1NvmQfDrzNx+veQe8dHbKag5n5CPeRxMhC4RAGLhlvlt
         +oHGNfg8hMNq9HG0iqUWTSz+Hj0zpnY9iMK0vZljFWjaAA17whBdYnwE87HCeOqdAf5e
         CRV7cNNCPvdaruPGbHujBk7h38Y2um8rvHhS7kBJg1a1pcqr3NGTEKkIYgi61FA55wn/
         sobw==
X-Gm-Message-State: AOAM531UuJFBEIltr4ADSBwQta6cyyy1ZXfzdoPd0D4FLSTj25ENiQI+
        cdNpQEMNHV8ly8zkmGh6nJSJny4VVaFaow==
X-Google-Smtp-Source: ABdhPJwAh5eLMHrPai0VNx94cdnNrnhRTNrFKUwxQB4WkMTaZfdJFDFAoT2h4yBUrsqH2Gim34zjhA==
X-Received: by 2002:a65:6118:: with SMTP id z24mr8644793pgu.191.1608219856009;
        Thu, 17 Dec 2020 07:44:16 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id na6sm4736607pjb.12.2020.12.17.07.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:44:15 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:44:11 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <X9t8y3rElyAPCLoD@google.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Oct 10, 2020 at 05:53:06PM +0800, Chao Yu wrote:
> On 2020/10/5 15:36, Satya Tangirala wrote:
> > This patch series adds support for metadata encryption to F2FS using
> > blk-crypto.
> 
> It looks this implementation is based on hardware crypto engine, could you
> please add this info into f2fs.rst as well like inlinecrypt...
> 
To be precise, the implementation requires either a hardware crypto
engine *or* blk-crypto-fallback. I tried to clarify this a little better
in the commit messages and in fscrypt.rst, but thinking about it again
now, I think I should add a section about metadata encryption at the end
of f2fs.rst. I'll do that when I send out v3 of this patch series (I
just sent out v2).
> > 
> > Patch 3 wires up F2FS with the functions introduced in Patch 2. F2FS
> > will encrypt every block (that's not being encrypted by some other
> > encryption key, e.g. a per-file key) with the metadata encryption key
> > except the superblock (and the redundant copy of the superblock). The DUN
> > of a block is the offset of the block from the start of the F2FS
> > filesystem.
> 
> Why not using nid as DUN, then GC could migrate encrypted node block directly via
> meta inode's address space like we do for encrypted data block, rather than
> decrypting node block to node page and then encrypting node page with DUN of new
> blkaddr it migrates to.
> 
The issue is, the bi_crypt_context in a bio holds a single DUN value,
which is the DUN for the first data unit in the bio. blk-crypto assumes
that the DUN of each subsequent data unit can be computed by simply
incrementing the DUN. So physically contiguous data units can only be put
into the same bio if they also have contiguous DUNs. I don't know much
about nids, but if the nid is invariant w.r.t the physical block location,
then there might be more fragmentation of bios in regular read/writes
(because physical contiguity may have no relation to DUN contiguity). So I
think we should continue using the fsblk number as the DUN.
