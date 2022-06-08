Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8012B543F21
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 00:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbiFHW2N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 18:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiFHW2J (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 18:28:09 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5821142ED0;
        Wed,  8 Jun 2022 15:28:08 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1033)
        id E908320BE66A; Wed,  8 Jun 2022 15:28:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E908320BE66A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654727287;
        bh=MF2Y1CBDjZevU8fKZUp5kTEpEkoKnGareWA0GYzqeq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rTkhDmYdY7rpVbQEn9L9mKl43RlPXNjWiPuTNIqmZzVD1Iy9c2bksxjgfYkkouLUq
         UPAyhyoSZskG+YgEI73GZWcdXpE59XsE7Wc7P1fKK/FdeMciH5m3kdKbrOjuvWo3TL
         GZqDCdh02EtKnOhBTJsUGaZi51u2R0kWzglRF03M=
Date:   Wed, 8 Jun 2022 15:28:07 -0700
From:   Deven Bowers <deven.desai@linux.microsoft.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 10/17] block|security: add LSM blob to block_device
Message-ID: <20220608222807.GA7650@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-11-git-send-email-deven.desai@linux.microsoft.com>
 <14754d16-75ae-cc92-cfc5-adce0628d9d9@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14754d16-75ae-cc92-cfc5-adce0628d9d9@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 08, 2022 at 01:07:39PM -0700, Casey Schaufler wrote:
> On 6/8/2022 12:01 PM, Deven Bowers wrote:
> >block_device structures can have valuable security properties,
> >based on how they are created, and what subsystem manages them.
> >
> >By adding LSM storage to this structure, this data can be accessed
> >at the LSM layer.
> >
> >Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Not everyone is going to appreciate the infrastructure allocation
> of the block_device security blob, but I do.

Thanks Casey.

