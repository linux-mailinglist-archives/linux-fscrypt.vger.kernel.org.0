Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2DE6576A2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Dec 2022 13:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiL1Mub (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Dec 2022 07:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiL1Mua (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Dec 2022 07:50:30 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99741100F
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Dec 2022 04:50:29 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BSCoCH7008131
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Dec 2022 07:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1672231814; bh=uak1jgcZONJWkQcvhw58/SlzJBPz95ZtmHeL63ZOSyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=aEWijW9a7/KBIBcgIW0Tvv5N/DK9NOZfmxs+FGiA4Jc1/bj3bFVQGB8GsmCk/rE96
         ZFH0BI9E+AyMmSqB6Y2fHPrBmxoFp8plifvamZEIVj8Wap7dqYIGcgEDm01NgOZXvw
         scXGIP9WDVO8BjmEmQ1x7fn3AUod7LOS7miaVEjMlpWmaljYsPatxdmSBsh4/uig5F
         Yy9ATu2A/cGzDqUU0bD/tFPNTS9R9/2c1ajZsYF1ZJf4eHouTFfX+8He9EIjNpT3qf
         ZL2haIqk8AQOPA14nBKSYIUmhtwhZGH9m+c4+ODCONzE6+IXKbkAvvlXplm0nrb63O
         MAoxc/+U9Y6Ww==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4A33015C4930; Wed, 28 Dec 2022 07:50:12 -0500 (EST)
Date:   Wed, 28 Dec 2022 07:50:12 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 08/10] generic/574: test multiple Merkle tree block
 sizes
Message-ID: <Y6w7hIQrZ37HbAng@mit.edu>
References: <20221223010554.281679-1-ebiggers@kernel.org>
 <20221223010554.281679-9-ebiggers@kernel.org>
 <20221225124600.faouh6a7suhq2wuu@zlang-mailbox>
 <Y6kvXs33MmxVovNO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6kvXs33MmxVovNO@sol.localdomain>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Dec 25, 2022 at 09:21:34PM -0800, Eric Biggers wrote:
> The joy of working with a shell scripting system where everyone has different
> versions of everything installed...

And this is why some large companies are still stuck on Bash v3
because the SRE's are afraid that untold number of shell scripts will
break in subtle and entertaining ways, leading to customer outages...

      	 	    		       	       	  - Ted
