Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB8776640
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjHIRTa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjHIRTa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:19:30 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8791703
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:19:29 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-76c9334baedso7157885a.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691601569; x=1692206369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YBEE6pa1JqtibEwuTLUswu8Sr+iHU/QjWeqfjBFoDM=;
        b=ZV99n1p12IM6O2ELZ49PhxekvruBA5827tHFjOZWWor+QL9d9x9F5e0IbhmXhXdioJ
         LgXe5FT3xqcArKxRemiD7/1xyS8HXE+sl855SaDSFzU39hW//TO7TO8bmY3RGTjDR/Xx
         053IKfL/w2MuIV9g+Jjsbw+WVT3e5MEXJQFBYbEboTNWcjNO7rNkw4cZbCUDktj+B0gX
         /YnIpIJmBa4Zuq0tgc8qKe7G2fqsPsNv0wdNq8cf/Nzg0rCtloJzW5Q5dN8QQQ6fBMSZ
         cB7BJLs9/bpkg7RiDGWV4B3suLR+QIYeWA9G3gsHFU4DZag104xSQuDScOt54uZnAgiB
         SDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691601569; x=1692206369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YBEE6pa1JqtibEwuTLUswu8Sr+iHU/QjWeqfjBFoDM=;
        b=AVAw4i5CtSRQ8R4vbr9D7XwOn6VZxmxq7fQMn8Hxpe+22cLIMOrBs30KdLHv9nDmu/
         po0aV0IvAZ6KoBDfNPRYTiCkbDwJ6d5klCu0/6MdpoG/X68+lg9s3iEN2weMP95RAP66
         n2PXBC18aBzti9NGKqr5XWZ7bcx9m2CMOV+AWF4V2a5sroP1wZGfxrVQVu2PK80+i9ZP
         uB84y7lyCNW3omAX5JbPLiZtpGHOJFPsDrQ2yqbeEVbxEbe1+ZUwj4+7vF05Dtwm7+mn
         gDH0u9Tdo+7InQJ0FWyvKKmjy5wX2sIpvCGoALufPD305X1k9hEehqhRCSF/P0CM6xbt
         mn2w==
X-Gm-Message-State: AOJu0YyBg7Q/rivxdL8GCrPCvkZS5ISlU7jINLjqgamsObN33kd+vZT6
        qKEaOCWjk2m1FO05S1yN9yesJQ==
X-Google-Smtp-Source: AGHT+IHMmz1DPNKw2ZD2Y5jXQFtMAiKv8wFSYQUqkQSh75Gqj8mocqD8RzJt42qnd2mCqKzQ7d1Lww==
X-Received: by 2002:a0c:b2c9:0:b0:626:290f:3e80 with SMTP id d9-20020a0cb2c9000000b00626290f3e80mr2921500qvf.50.1691601568979;
        Wed, 09 Aug 2023 10:19:28 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id f17-20020a05620a12f100b00767f14f5856sm4156964qkl.117.2023.08.09.10.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:19:28 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:19:27 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 1/8] fscrypt: move inline crypt decision to info setup
Message-ID: <20230809171927.GB2516732@perftesting>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <f1f1a99ff06dd097990da72d343cadb391de0726.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1f1a99ff06dd097990da72d343cadb391de0726.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:01PM -0400, Sweet Tea Dorminy wrote:
> setup_file_encryption_key() is doing a lot of things at the moment --
> setting the crypt_info's inline encryption bit, finding and locking a
> master key, and calling the functions to get the appropriate prepared
> key for this info. Since setting the inline encryption bit has nothing
> to do with finding the master key, it's easy and hopefully clearer to
> select the encryption implementation in fscrypt_setup_encryption_info(),
> the main fscrypt_info setup function, instead of in
> setup_file_encryption_key() which will long-term only deal in setting
> up the prepared key for the info.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
