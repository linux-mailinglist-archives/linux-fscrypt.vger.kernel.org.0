Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D25B26AF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiIHT1v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 15:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiIHT1u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 15:27:50 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED2B07FF
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 12:27:49 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id a10so13693036qkl.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 12:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uJuSEBAP6rRmrIWIihpoeQUrSgdohwiep3NB3gaWFo8=;
        b=yOlyV7wO/K1OUz538EHIg5BEWLzOUoIbe/xVlYV5eND8thb58u5gUIB1TnmxVUrqr0
         yqR3sjJwDzY/lLXtMLhy3clM7I8hz4cofsAZC3y6nJecgbVAdJ0wob/BYoKYNLnkWYSM
         cL5wrJ/dX3IvNILBL0u9lCqw9xBVZgg+Q7KdWJFhd6K8O5tO3tJ2yCPZq8zr5xqQ1aO1
         WwAmuZs1RoPQMEnFL0kzQqNfmog/i05rKEoBg6PwDWJkBPsbcH1cJcCtadFe3wZKdLXg
         QpbsuW++91IGbQjOTsNXlJICtjVL0WJ6ci6S/vgxqT8hIKuFClz1PQHqZr3sUCgOYpQb
         +NgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uJuSEBAP6rRmrIWIihpoeQUrSgdohwiep3NB3gaWFo8=;
        b=QwFDwM/0pm5BrVvO+xll2Lv2mTJ8YUqnr+i2C/VumXc4DkSYumVIFoS5OmpqjSAce8
         PBe5Lt/0zGm9tpWCGihKY0KHgYvSVKIHI33mupwezd5AOxl4c9+LlJSmduVesNEcLqF0
         PwZSK4hqYbsspdsJBP77U66tKPEXfWtMDi8nrg/Ro/a3AzxRwOS4k5V503Inb6RkOfJC
         yLzsAUpkPktDn6c3tSjuk1uTu6lR/mvrdFImGfdYvwPyjpyhc1G5EtCx5FvVSdaKMy1l
         vvdj6ZrJIstTJr3ZHDDVaQE4NNxQ1vPzRf4TSGloCYYlaqTrHKCdVdI4jZ1UlvZPDHRH
         ty6g==
X-Gm-Message-State: ACgBeo3kImw5H+SB6mCUJip7Qlu2gWDKs3SSB8fIggXhBlv84Us3Hjkr
        lsSNTodAUgmM7R0r0sW29yRiBA==
X-Google-Smtp-Source: AA6agR5b101O8bqi/mKgFUPKgcze67lg/xw/eC/6lXVh2fXekpAJIuULI5EMueFWazFpTkS2hHppVg==
X-Received: by 2002:a05:620a:4394:b0:6be:6fdb:a7b2 with SMTP id a20-20020a05620a439400b006be6fdba7b2mr7252830qkp.345.1662665268491;
        Thu, 08 Sep 2022 12:27:48 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id m11-20020a05620a290b00b006bb87c4833asm18673091qkp.109.2022.09.08.12.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:27:47 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:27:46 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <YxpCMuWb80TjbVgU@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:25PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Now that everything in btrfs is dealing in fscrypt_names, fscrypt has a
> useful function, fscrypt_match_name(), to check whether a fscrypt_name
> matches a provided buffer. However, btrfs buffers are struct
> extent_buffer rather than a raw char array, so we need to implement our
> own imitation of fscrypt_match_name() that deals in extent_buffers,
> falling back to a simple memcpy if fscrypt isn't compiled. We
> can then use this matching method in btrfs_match_dir_item_name() and
> other locations.
> 
> This also provides a useful occasion to introduce the new fscrypt file
> for btrfs, handling the fscrypt-specific functions needed.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

The code is fine, but I was very confused about why we do this sha256 thing.
Perhaps point at the code for fscrypt_nokey_name and indicate that it exists to
be interoperable with no-key actions on the file system.  Thanks,

Josef
