Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30BB8ED00
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfHONhW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 09:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732255AbfHONhW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 09:37:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5507F307D90D;
        Thu, 15 Aug 2019 13:37:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B21F1C6;
        Thu, 15 Aug 2019 13:37:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190814222822.GA101319@gmail.com>
References: <20190814222822.GA101319@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-fscrypt@vger.kernel.org, linux-next@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: Merge resolution for fscrypt and keyrings trees
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12088.1565876240.1@warthog.procyon.org.uk>
Date:   Thu, 15 Aug 2019 14:37:20 +0100
Message-ID: <12089.1565876240@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 15 Aug 2019 13:37:22 +0000 (UTC)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:

> +static struct key_acl fscrypt_keyring_acl = {
> +	.usage = REFCOUNT_INIT(1),
> +	.nr_ace	= 2,
> +	.aces = {
> +		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL |
> +				  KEY_ACE_JOIN),
> +		KEY_OWNER_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL | KEY_ACE_JOIN |
> +			      KEY_ACE_READ | KEY_ACE_VIEW),
> +	}
> +};

Does you really want JOIN permission for these keyrings?  Are you permitting
them to be used with KEYCTL_JOIN_SESSION_KEYRING?  Do you also want INVAL for
the keyring rather than just the keys it contains?  Would CLEAR be more
appropriate?

> +static struct key_acl fscrypt_key_acl = {
> +	.usage = REFCOUNT_INIT(1),
> +	.nr_ace	= 2,
> +	.aces = {
> +		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL |
> +				  KEY_ACE_JOIN),
> +		KEY_OWNER_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL | KEY_ACE_JOIN |
> +			      KEY_ACE_VIEW),
> +	}
> +};

JOIN permission is useless here.  This is only used for keys of type
key_type_fscrypt that I can see - and those aren't keyrings and so aren't
joinable.

> +static struct key_acl fscrypt_user_key_acl = {

Ditto.

David
