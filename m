Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E872D522EA9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 10:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiEKIpc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 May 2022 04:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243908AbiEKIpb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 May 2022 04:45:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 870EE200F5D
        for <linux-fscrypt@vger.kernel.org>; Wed, 11 May 2022 01:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652258729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PuXaOU3NnRKmgPtIyKPrxsMW3p/EiJXw3Bu9v33q5n0=;
        b=PrzDTGzh5VXfj7dglWVKJZrxoI7djk+aoDvWkHhun34uOzqUbAd0PHvRkXxlRbMkPYOhM8
        qEsc77/WrH9FQFZjkjfVeWJvMXfkxoifor62xu18SgfnEPcCORf54iERUpeQayonoWpLnV
        djaAaLY9+fVMCxiuP/rWN4SPT14cenM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-tNGE-ZDJPWqBLXUkT02_NQ-1; Wed, 11 May 2022 04:45:23 -0400
X-MC-Unique: tNGE-ZDJPWqBLXUkT02_NQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06A178047D6;
        Wed, 11 May 2022 08:45:23 +0000 (UTC)
Received: from fedora (unknown [10.40.194.0])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17F41C2810D;
        Wed, 11 May 2022 08:45:21 +0000 (UTC)
Date:   Wed, 11 May 2022 10:45:19 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [xfstests PATCH 1/2] ext4/053: update the test_dummy_encryption
 tests
Message-ID: <20220511084519.aneysdmu2dburqus@fedora>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220501051928.540278-2-ebiggers@kernel.org>
 <Ym/Sk7D17iCeQIJa@mit.edu>
 <YnASjrPbudBXCYfK@sol.localdomain>
 <Ynp8b+Gocx3A/NbW@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynp8b+Gocx3A/NbW@mit.edu>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 10, 2022 at 10:53:35AM -0400, Theodore Ts'o wrote:
> On Mon, May 02, 2022 at 10:19:10AM -0700, Eric Biggers wrote:
> > 
> > We could gate them on the kernel version, similar to the whole ext4/053 which
> > already only runs on kernel version 5.12.  (Kernel versions checks suck, but
> > maybe it's the right choice for this very-nit-picky test.)  Alternatively, I
> > could just backport "ext4: only allow test_dummy_encryption when supported" to
> > 5.15, which would be the only relevant LTS kernel version.
> 
> If we don't need the "only allow test_dummy_encryption when supported"
> in any Android, Distro, or LTS kernel --- which seems to be a
> reasonable assumption, that seems to be OK.  Lukas, do you agree?

Yes I think this a reasonable approach.

> 
> In the long term I suspect there will be times when we want to
> backport mount option handling changes to older kernels, and we're
> going to be hit this issue again, but as the saying goes, "sufficient
> unto the day is the evil thereof".

That is true and while it is a bit annoying to deal with I think that we
generally have to keep the user facing mount option behaviour stable.
The 053 test is helping with that for the price of some nuisance when
we actually want to change the behaviour. For now I think it's a
worthwhile trade-off.

-Lukas

> 
>      	 				- Ted
> 				
> 

