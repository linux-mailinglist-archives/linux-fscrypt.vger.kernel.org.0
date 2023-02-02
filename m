Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530D368723C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 01:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBBAT0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Feb 2023 19:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBBATZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Feb 2023 19:19:25 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD52A6D5E1;
        Wed,  1 Feb 2023 16:19:24 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 6706120B7102; Wed,  1 Feb 2023 16:19:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6706120B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675297164;
        bh=4Dh1wm0+1J+7ggoI5S+eoWDvn+A0VT5pfhAZ4EHzjXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jEeNLiLmjX64OuGsdTuBuNsk8WTsg1yq+Hv0Iy9ep5bGfVIoT/wb5fD2FoTH8XSRv
         t7lmikGDu11HkkiNRAq/XW11kbtTpiFiugDEDhWnOEY7U0iR2hP94Fz+xH4mD/jg2d
         d7uEQbmHKzS1D0fSpNdu4lNHgre4JmmAYNHb9xoM=
Date:   Wed, 1 Feb 2023 16:19:24 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 16/16] documentation: add ipe documentation
Message-ID: <20230202001924.GD9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-17-git-send-email-wufan@linux.microsoft.com>
 <Y9iSP+RxY+1/o7PQ@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9iSP+RxY+1/o7PQ@debian.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 31, 2023 at 10:59:59AM +0700, Bagas Sanjaya wrote:
> On Mon, Jan 30, 2023 at 02:57:31PM -0800, Fan Wu wrote:
> 
> What about wordings below instead?

Thanks for the review!
>  
> -IPE policy supports comments. The character '#' will function as a
> -comment, ignoring all characters to the right of '#' until the newline.
> +IPE policy supports comments. Any line which is prefixed with ``#`` will
> +be ignored.
This one is actually incorrect. The '#' can also appear at the end of a rule.
So it is not only prefixed to a line.

Other than this part, everything looks great, I will take them in the next
version.

-Fan

>  
>  -----------
> 
> Thanks.
> 
> -- 
> An old man doll... just what I always wanted! - Clara


