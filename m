Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2814F547D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Apr 2022 07:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385111AbiDFFRE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Apr 2022 01:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573509AbiDETNz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Apr 2022 15:13:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3E9E885A;
        Tue,  5 Apr 2022 12:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8530EB81FA2;
        Tue,  5 Apr 2022 19:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D2AC385A3;
        Tue,  5 Apr 2022 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649185911;
        bh=iqDVStRGWXOC77cY1v8kziYHdtofJiyJcwhxPZyHrbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aLEMuI3pesvK6tTddYPd7tLH6xqK53mL9EL/1QzdSFFDsK5N4EdY1LIVnfurkf8d7
         BkJukhkF+kv3CQ9PLpfN0qAU8pzWM70ZdrXidS0aNhBClngiuWHJ6I85GU1hdi0WWt
         hBywYF1O/c5L3zhHAviInVrbXd4/whLDJq1cHeys+Qjci7C4+joCjfJVDMLCoZVb6U
         m3S0dz+1WlxZPW2eV/Tquo7WTkLeF9z0icfXGEGHZZplTblFgpq0JH2mU1DGI8ODlv
         DgUgy8TTUHhhkuiXA4mhefyvy1PTrAVpVUtCBg8USciqeKb99t7MjokKbT6OPx0+V+
         VYUwwgit8OhpQ==
Date:   Tue, 5 Apr 2022 19:11:48 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/5] ima: define a new template field named 'd-ngv2'
 and templates
Message-ID: <YkyUdM5hmKf4noS7@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-3-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325223824.310119-3-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 25, 2022 at 06:38:21PM -0400, Mimi Zohar wrote:
>  static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> -				       u8 hash_algo,
> +				       u8 digest_type, u8 hash_algo,
>  				       struct ima_field_data *field_data)
>  {
>  	/*
>  	 * digest formats:
>  	 *  - DATA_FMT_DIGEST: digest
>  	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> +	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> +	 *	[<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
> +	 *    where <hash type> is either "ima" or "verity",
>  	 *    where <hash algo> is provided if the hash algorithm is not
>  	 *    SHA1 or MD5

This says both "hash type" and "digest type".  It should be one or the other.

The square brackets are meant to indicate that the part within it is optional,
right?  Are they in the right place?  I don't see how this matches the code.
There is also no explanation for why or when <digest type> is optional with
DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO.

> +	if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
> +		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> +		offset += snprintf(buffer, DIGEST_TYPE_NAME_LEN_MAX +
> +				   CRYPTO_MAX_ALG_NAME + 1, "%*s:%s",
> +				   (int)strlen(digest_type_name[digest_type]),
> +				   digest_type_name[digest_type],
>  				   hash_algo_name[hash_algo]);
>  		buffer[offset] = ':';
>  		offset += 2;

There's no need to use %*s if the length argument is just going to be strlen().
It should just use %s.

Also, this is not correct use of snprintf(), given that the string is
unconditionally appended to at the offset which snprintf() returns.  So it is
not providing buffer overflow protection.  It might as well just be:

                offset += 1 + sprintf(buffer, "%s:%s:",
                                      digest_type_name[digest_type],
                                      hash_algo_name[hash_algo]);

and likewise for the other case:

                offset += 1 + sprintf(buffer, "%s:", hash_algo_name[hash_algo]);

> +/*
> + * This function writes the digest of an event (without size limit),
> + * prefixed with both the hash type and algorithm.
> + */
> +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
> +			      struct ima_field_data *field_data)
> +{
> +	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;

Why is this defaulting to SHA-1?

- Eric
