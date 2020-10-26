Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B4B2996B8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 20:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504808AbgJZTV1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 15:21:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46404 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1784386AbgJZTV0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 15:21:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id n6so13977669wrm.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 12:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=a5yGSmSk7T54uAGSRj/AxdMJXSmLSnYi0bWDzEjQaz4=;
        b=Iuh2tPg+NmaryShGYRrDY3aJ9BW2IqUbqsJS1hCaM2pISkaWR9McSX3+UwrnbtuP35
         5rM0MXJLxn7GQ6RFyio8dSHPE7Xa5fesZLfTvx51lCilIhlGdbdyO+VtQYEmYn5+4TzP
         zuuqwYRVkx9H6XrVwK4c0v1mayvFYdtHdqKEic2cWqnuJdTs3b56iaiUKe6Jqfck556t
         8pjmMg8g6/e1CDY4uS9WmlhKz/jFUpbvVXZgAuMEIDNm96WijC3+QA0Af7LEJDjPDoZB
         qQz5gbwcmjelVTvrmDrBMlTXrTEnXARBZXoVUqEO/Ka760ddB3fvV8+o/vUoZpokC+GZ
         PzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=a5yGSmSk7T54uAGSRj/AxdMJXSmLSnYi0bWDzEjQaz4=;
        b=GHOH+J0u2f7PGxpVvb482qAjmglLcl9LzlD6XHf97DMFlUpQEG+p1HFMcB+omrxjlH
         Jbrdsdy5GCdxqoFSpzbZwT8O6PcCHAPYogK4gbLaXyNAWNh3JqPZ31zFca1JsCPB/tmS
         p45KCs7cLYAu2mp3SJhINtMxVZqiwv5mf9FMPu8wMO0Opzjooh8WwbnJccydlOWMrB69
         GB2G/0obk+SzJHgaYwd6RrsWCEQUW+VexXVwR75o3LSsLtCVwBukJQ56MAQWTjeabd4k
         tDnHu5RWFDWMAttpo2q20UQbhzcdJ2fBNH+sjzXgiygrG3uN8j8Rr0CEcHUxNNT/0TJB
         dUCw==
X-Gm-Message-State: AOAM531yZHQBWfi07t0hd84sVSSxWpmpSw6Vx0rBdBcEkNczqOwBxJto
        2hCSjPNfqZh1W3TYC2QIkw4=
X-Google-Smtp-Source: ABdhPJzefcdPXN+q9CrUzyW0QVgIZbanSQita5Pfn7RHoV4kP1F99yw3IOJOFPbt8ZroI6OMC9N2dg==
X-Received: by 2002:a5d:5387:: with SMTP id d7mr19379415wrv.224.1603740083712;
        Mon, 26 Oct 2020 12:21:23 -0700 (PDT)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id o140sm22879827wme.43.2020.10.26.12.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 12:21:23 -0700 (PDT)
Message-ID: <5553b3c21007034bc40175801a0b89ec35c8f1f1.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH v4] Add digest sub command
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Mon, 26 Oct 2020 19:21:22 +0000
In-Reply-To: <20201026185806.GK858@sol.localdomain>
References: <20201026181105.3322022-1-luca.boccassi@gmail.com>
         <20201026181729.3322756-1-luca.boccassi@gmail.com>
         <20201026185806.GK858@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2020-10-26 at 11:58 -0700, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 06:17:29PM +0000, luca.boccassi@gmail.com wrote:
> > +/* Compute a file's fs-verity measurement, then print it in hex format. */
> > +int fsverity_cmd_digest(const struct fsverity_command *cmd,
> > +		      int argc, char *argv[])
> 
> Since it can be more than one file now:
> 
> /* Compute the fs-verity measurement of the given file(s), for offline signing */

Applied in v5.

> > +	for (int i = 0; i < argc; i++) {
> > +		struct filedes file = { .fd = -1 };
> > +		struct fsverity_signed_digest *d = NULL;
> > +		struct libfsverity_digest *digest = NULL;
> > +		char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
> > +
> > +		if (!open_file(&file, argv[i], O_RDONLY, 0))
> > +			goto out_err;
> > +
> > +		if (!get_file_size(&file, &tree_params.file_size))
> > +			goto out_err;
> 
> 'file' doesn't get closed on error.  Making it back to the outer scope would fix
> that.

Added to out_err in v5 (I had ignored it as cmd_sign does currently).

> > +		if (compact)
> > +			printf("%s\n", digest_hex);
> > +		else
> > +			printf("%s:%s %s\n",
> > +				libfsverity_get_hash_name(tree_params.hash_algorithm),
> > +				digest_hex, argv[i]);
> 
> I don't think the hash algorithm should be printed in the
> '!compact && for_builtin_sig' case, since it's already included in the struct
> that gets hex-encoded.  I.e.
> 
> 		else if (for_builtin_sig)
> 			printf("%s %s\n", digest_hex, argv[i]);

Fixed in v5.

> > diff --git a/programs/fsverity.c b/programs/fsverity.c
> > index 95f6964..c7c4f75 100644
> > --- a/programs/fsverity.c
> > +++ b/programs/fsverity.c
> > @@ -21,6 +21,14 @@ static const struct fsverity_command {
> >  	const char *usage_str;
> >  } fsverity_commands[] = {
> >  	{
> > +		.name = "digest",
> > +		.func = fsverity_cmd_digest,
> > +		.short_desc = "Compute and print hex-encoded fs-verity digest of a file, for offline signing",
> 
> Likewise, since this can now accept multiple files:
> 
> "Compute the fs-verity measurement of the given file(s), for offline signing"
> 
> (I don't think that "printed as hex" needs to be explicitly mentioned here.)

Done in v5.

-- 
Kind regards,
Luca Boccassi

